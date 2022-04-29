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
        Product product;
    }

    uint256 private idCount = 0;

    mapping(address => mapping(uint256 => SellableProduct)) public ownedSellableProducts;

    mapping(address => mapping(uint256 => Product)) private ownedNonSellableProducts;

    mapping(uint256 => TransactionDetails[]) public productHistory;

    Product[] private products;

    uint256 private feePricePercentage = 2;

    function setFeePercentage(uint256 _feePercentage) external onlyOwner {
        feePricePercentage = _feePercentage;
    }

    function clone(Product memory product) internal pure returns (Product memory) {
        return Product(product.id, product.owner, product.name, product.description, product.link, product.tags, product.forSale);
    }

    function listProductForSale(string memory _name, string memory _description, string memory _link, string[] memory _tags, uint256 _price) external {
        uint256 id = idCount++;
        Product memory product = Product(id, msg.sender, _name, _description, _link, _tags, true);
        products.push(product);
        ownedSellableProducts[msg.sender][id] = SellableProduct(_price, _price * feePricePercentage / 100, block.timestamp, product);
    }

    function addNonSellableProduct(string memory _name, string memory _description, string memory _link, string[] memory _tags) external {
        uint256 id = idCount++;
        Product memory product = Product(id, msg.sender, _name, _description, _link, _tags, false);
        products.push(product);
        ownedNonSellableProducts[msg.sender][id] = product;
    }

    function transferFromSellableToNonSellable(address _ownerSellable, address _ownerNonSellable, uint256 _productId) internal {
        ownedNonSellableProducts[_ownerNonSellable][_productId] = ownedSellableProducts[_ownerSellable][_productId].product;
        ownedNonSellableProducts[_ownerNonSellable][_productId].owner = _ownerNonSellable;
        ownedNonSellableProducts[_ownerNonSellable][_productId].forSale = false;
        products[_productId].owner = _ownerNonSellable;
        products[_productId].forSale = false;
        delete(ownedSellableProducts[_ownerSellable][_productId]);
    }

    function transferFromNonSellableToSellable(address _owner, uint256 _productId, uint256 price) internal {
        ownedSellableProducts[_owner][_productId] = SellableProduct(price, price * feePricePercentage / 100, block.timestamp, ownedNonSellableProducts[_owner][_productId]);
        ownedSellableProducts[_owner][_productId].product.forSale = true;
        products[_productId].forSale = true;
        delete(ownedNonSellableProducts[_owner][_productId]);
    }

    function listExistingProductForSale(uint256 _productId, uint256 _price) external {
        require(ownedNonSellableProducts[msg.sender][_productId].owner == msg.sender, "Sender is not the owner of the product!");
        transferFromNonSellableToSellable(msg.sender, _productId, _price);
    }
    
    function buyProduct(uint256 productId, address productSeller) external payable {
        SellableProduct memory soldProduct = ownedSellableProducts[productSeller][productId];
        require(soldProduct.product.owner == productSeller && msg.value >= soldProduct.price + soldProduct.fees, "Not enough wei sent!");
        (bool success, ) = payable(productSeller).call{value: soldProduct.price}("");
        require(success, "Transaction failed!");
        
        productHistory[productId].push(TransactionDetails(soldProduct.price, soldProduct.fees, soldProduct.datetime, productSeller, msg.sender));
        transferFromSellableToNonSellable(productSeller, msg.sender, productId);

        (success, ) = payable(owner()).call{value: soldProduct.fees}("");
        require(success, "Fees payment failed but transaction was successful!");
    }

    function getAllProductsForSale(uint256 startIndexForSearch, uint256 maxResults) external view returns (uint256, Product[] memory) {
        Product[] memory productsForSale = new Product[](products.length);
        uint productsForSaleCounter = 0;
        uint i;
        for (i = startIndexForSearch; i < products.length && productsForSaleCounter < maxResults; i++) {
            if (products[i].forSale) {
                productsForSale[productsForSaleCounter++] = products[i];
            }
        }
        return (i, productsForSale);
    }

    function filterSellingProducts(string memory partialTitle, string memory category, address owner, uint256 date, uint256 startIndexForSearch, uint256 maxResults) external view returns (uint256, Product[] memory) {
        Product[] memory productsForSale = new Product[](products.length);
        uint productsForSaleCounter = 0;
        uint i;
        for (i = startIndexForSearch; i < products.length && productsForSaleCounter < maxResults; i++) {
            if (!products[i].forSale) {
                continue;
            }
            bool isValid = true;
            bytes32 categoryHash = keccak256(abi.encodePacked(category));
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
                (owner != address(0) || owner == products[i].owner) &&
                (date != 0 || date <= ownedSellableProducts[products[i].owner][i].datetime) &&
                containsWord(partialTitle, products[i].name)    // don't need to check for empty string since it's included into the product name
            )) {
                isValid = false;
            }
            if (isValid) {
                productsForSale[productsForSaleCounter++] = products[i];
            }
        }
        return (i, productsForSale);
    }

    function getHistoryForProduct(uint256 productId) external view returns (TransactionDetails[] memory) {
        return productHistory[productId];
    }

    function getSellableProductDetails(uint256 productId) external view returns (SellableProduct memory) {
        Product memory product = products[productId];
        require(product.forSale == true);
        return ownedSellableProducts[product.owner][productId];
    }

    function containsWord(string memory what, string memory where) internal pure returns (bool found) {
        bytes memory whatBytes = bytes (what);
        bytes memory whereBytes = bytes (where);
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
}