pragma solidity >=0.8.0 <0.9.0;

import "./Ownable.sol";

contract MarketPlace is Ownable {
    struct Product {
        uint256 id;
        address owner;
        string name;
        string description;
        string link;
        string[] tags;
        bool forSale;
    }

    struct TransactionDetails {
        uint256 price;
        uint256 fees;
        uint256 datetime;
        address seller;
        address buyer;
    }

    struct SellableProduct {
        // wei price
        uint256 price;
        uint256 fees;
        uint256 datetime;
        uint256 productId;
    }

    uint256 private idCount = 0;

    mapping(address => mapping(uint256 => SellableProduct)) public ownedSellableProducts;

    mapping(address => mapping(uint256 => bool)) private ownedNonSellableProducts;

    mapping(uint256 => TransactionDetails[]) public productHistory;

    Product[] private products;

    uint256 private feePricePercentage = 2;

    modifier isProductOwner(uint256 _productId, address _owner) {
        require(products[_productId].owner == _owner, "The supplied address is not the owner of the product!");
        _;
    }

    function setFeePercentage(uint256 _feePercentage) external onlyOwner {
        feePricePercentage = _feePercentage;
    }

    function clone(Product memory _product) internal pure returns (Product memory) {
        return Product(_product.id, _product.owner, _product.name, _product.description, _product.link, _product.tags, _product.forSale);
    }

    function listProductForSale(string memory _name, string memory _description, string memory _link, string[] memory _tags, uint256 _price) external {
        uint256 id = idCount++;
        Product memory product = Product(id, msg.sender, _name, _description, _link, _tags, true);
        products.push(product);
        ownedSellableProducts[msg.sender][id] = SellableProduct(_price, _price * feePricePercentage / 100, block.timestamp, id);
    }

    function addNonSellableProduct(string memory _name, string memory _description, string memory _link, string[] memory _tags) external {
        uint256 id = idCount++;
        Product memory product = Product(id, msg.sender, _name, _description, _link, _tags, false);
        products.push(product);
        ownedNonSellableProducts[msg.sender][id] = true;
    }

    function transferFromSellableToNonSellable(address _ownerSellable, address _ownerNonSellable, uint256 _productId) internal {
        ownedNonSellableProducts[_ownerNonSellable][_productId] = true;
        products[_productId].owner = _ownerNonSellable;
        products[_productId].forSale = false;
        delete(ownedSellableProducts[_ownerSellable][_productId]);
    }

    function transferFromNonSellableToSellable(address _owner, uint256 _productId, uint256 _price) internal {
        ownedSellableProducts[_owner][_productId] = SellableProduct(_price, _price * feePricePercentage / 100, block.timestamp, _productId);
        products[_productId].forSale = true;
        delete(ownedNonSellableProducts[_owner][_productId]);
    }

    function listExistingProductForSale(uint256 _productId, uint256 _price) external isProductOwner(_productId, msg.sender) {
        transferFromNonSellableToSellable(msg.sender, _productId, _price);
    }
    
    function buyProduct(uint256 _productId, address _productSeller) external payable isProductOwner(_productId, _productSeller) {
        SellableProduct memory soldProduct = ownedSellableProducts[_productSeller][_productId];
        require(msg.value >= soldProduct.price + soldProduct.fees, "Not enough wei sent!");
        (bool success, ) = payable(_productSeller).call{value: soldProduct.price}("");
        require(success, "Transaction failed!");
        
        productHistory[_productId].push(TransactionDetails(soldProduct.price, soldProduct.fees, soldProduct.datetime, _productSeller, msg.sender));
        transferFromSellableToNonSellable(_productSeller, msg.sender, _productId);

        (success, ) = payable(owner()).call{value: soldProduct.fees}("");
        require(success, "Fees payment failed but transaction was successful!");
    }

    function getAllProductsForSale(uint256 _startIndexForSearch, uint256 _maxResults) external view returns (uint256, Product[] memory) {
        Product[] memory productsForSale = new Product[](products.length);
        uint productsForSaleCounter = 0;
        uint i;
        for (i = _startIndexForSearch; i < products.length && productsForSaleCounter < _maxResults; i++) {
            if (products[i].forSale) {
                productsForSale[productsForSaleCounter++] = products[i];
            }
        }
        return (i, productsForSale);
    }

    function filterSellingProducts(string memory _partialTitle, string memory _category, address _owner, uint256 _date, uint256 _startIndexForSearch, uint256 _maxResults) external view returns (uint256, Product[] memory) {
        Product[] memory productsForSale = new Product[](products.length);
        uint productsForSaleCounter = 0;
        uint i;
        for (i = _startIndexForSearch; i < products.length && productsForSaleCounter < _maxResults; i++) {
            if (!products[i].forSale) {
                continue;
            }
            bool isValid = true;
            bytes32 categoryHash = keccak256(abi.encodePacked(_category));
            if (categoryHash != keccak256(abi.encodePacked(""))) {
                string[] memory tags = products[i].tags;
                uint j;
                for (j = 0; j < tags.length; j++) {
                    if (categoryHash == keccak256(abi.encodePacked(tags[j]))) {
                        break;
                    }
                }
                if (j >= tags.length) {
                    isValid = false;
                }
            }
            if (!(isValid &&
                (_owner != address(0) || _owner == products[i].owner) &&
                (_date != 0 || _date <= ownedSellableProducts[products[i].owner][i].datetime) &&
                containsWord(_partialTitle, products[i].name)    // don't need to check for empty string since it's included into the product name
            )) {
                isValid = false;
            }
            if (isValid) {
                productsForSale[productsForSaleCounter++] = products[i];
            }
        }
        return (i, productsForSale);
    }

    function getHistoryForProduct(uint256 _productId) external view returns (TransactionDetails[] memory) {
        return productHistory[_productId];
    }

    function getSellableProductDetails(uint256 _productId) external view returns (SellableProduct memory) {
        Product memory product = products[_productId];
        require(product.forSale == true);
        return ownedSellableProducts[product.owner][_productId];
    }

    function containsWord(string memory _what, string memory _where) internal pure returns (bool found) {
        bytes memory whatBytes = bytes(_what);
        bytes memory whereBytes = bytes(_where);
        if (whereBytes.length < whatBytes.length) { 
            return false; 
        }
        found = false;
        for (uint i = 0; i <= whereBytes.length - whatBytes.length; i++) {
            bool flag = true;
            for (uint j = 0; j < whatBytes.length; j++) {
                if (whereBytes [i + j] != whatBytes [j]) {
                    flag = false;
                    break;
                }
            }
            if (flag) {
                found = true;
                break;
            }
        }
        return found;
    }

    function getOwnerProducts(uint256 _startIndexForSearch, uint256 _maxResults) external view returns (uint256, Product[] memory) {
        address owner = msg.sender;
        Product[] memory ownerProducts = new Product[](products.length);
        uint256 ownerProductsCounter = 0;
        uint256 i;
        for (i = _startIndexForSearch; i < products.length && ownerProductsCounter < _maxResults; i++) {
            if (products[i].owner == owner) {
                ownerProducts[ownerProductsCounter++] = products[i];
            }
        }
        return (i, ownerProducts);
    }

    function checkProductOwnership(uint256 _productId) external view returns (address) {
        return products[_productId].owner;
    }
}