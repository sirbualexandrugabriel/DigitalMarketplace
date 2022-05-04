pragma solidity >=0.8.0 <0.9.0;

import "./ERC721.sol";
import "./Ownable.sol";

contract MarketPlace is Ownable, ERC721 {
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

    mapping(uint256 => address) private productToApprovedAddress;

    mapping(address => mapping(address => bool)) private addressToOperatorCheck;

    mapping(uint256 => TransactionDetails[]) public productHistory;

    Product[] private products;

    uint256 private feePricePercentage = 2;

    modifier isProductOwner(uint256 _productId, address _owner) {
        require(products[_productId].owner == _owner, "The supplied address is not the owner of the product!");
        _;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Couldn't withdraw!");
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
    
    function buyProduct(uint256 _productId, address _productSeller, address _productBuyer) public payable isProductOwner(_productId, _productSeller) {
        SellableProduct memory soldProduct = ownedSellableProducts[_productSeller][_productId];
        require(msg.value >= soldProduct.price + soldProduct.fees, "Not enough wei sent!");
        (bool success, ) = payable(_productSeller).call{value: soldProduct.price}("");
        require(success, "Transaction failed!");
        
        productHistory[_productId].push(TransactionDetails(soldProduct.price, soldProduct.fees, soldProduct.datetime, _productSeller, _productBuyer));
        transferFromSellableToNonSellable(_productSeller, _productBuyer, _productId);
    }

    function getAllProductsForSale(uint256 _startIndexForSearch, uint256 _maxResults) external view returns (uint256, Product[] memory) {
        uint resultSize = 0;
        uint i;
        for (i = _startIndexForSearch; i < products.length && resultSize < _maxResults; i++) {
            if (products[i].forSale) {
                resultSize++;
            }
        }
        Product[] memory productsForSale = new Product[](resultSize);
        uint productsForSaleCounter = 0;
        for (i = _startIndexForSearch; i < products.length && productsForSaleCounter < _maxResults; i++) {
            if (products[i].forSale) {
                productsForSale[productsForSaleCounter++] = products[i];
            }
        }
        return (i, productsForSale);
    }

    function filterSellingProducts(string memory _partialTitle, string memory _category, address _owner, uint256 _date, uint256 _startIndexForSearch, uint256 _maxResults) external view returns (uint256, Product[] memory) {
        uint i;
        uint resultSize = 0;
        for (i = _startIndexForSearch; i < products.length && resultSize < _maxResults; i++) {
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
                resultSize++;
            }
        }
        Product[] memory productsForSale = new Product[](products.length);
        uint productsForSaleCounter = 0;
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
        uint resultSize = 0;
        uint i;
        for (i = _startIndexForSearch; i < products.length && resultSize < _maxResults; i++) {
            if (products[i].owner == owner) {
                resultSize++;
            }
        }
        Product[] memory ownerProducts = new Product[](resultSize);
        uint256 ownerProductsCounter = 0;
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

    function getOwnerProductsNotForSale(uint256 _startIndexForSearch, uint256 _maxResults) external view returns (uint256, Product[] memory) {
        address owner = msg.sender;
        uint resultSize = 0;
        uint i;
        for (i = _startIndexForSearch; i < products.length && resultSize < _maxResults; i++) {
            if (products[i].owner == owner && !products[i].forSale) {
                resultSize++;
            }
        }
        Product[] memory ownerProducts = new Product[](resultSize);
        uint256 ownerProductsCounter = 0;
        for (i = _startIndexForSearch; i < products.length && ownerProductsCounter < _maxResults; i++) {
            if (products[i].owner == owner && !products[i].forSale) {
                ownerProducts[ownerProductsCounter++] = products[i];
            }
        }
        return (i, ownerProducts);
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) override external view returns (uint256) {
        require(_owner != address(0), "Address must not be 0");
        uint count = 0;
        for (uint i = 0; i < products.length; i++) {
            if(products[i].owner == _owner) count++;
        }
        return count;
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) override external view returns (address) {
        require(products[_tokenId].owner != address(0), "Address owner is 0");
        return products[_tokenId].owner;
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) override external payable {
        require(msg.sender == products[_tokenId].owner || addressToOperatorCheck[_from][_to] || productToApprovedAddress[_tokenId] == _to, "Permission denied");
        require(_to != address(0), "Cannot transfer to address 0");
        if (products[_tokenId].forSale) {
            buyProduct(_tokenId, _from, _to);
        }
        else {
            ownedNonSellableProducts[_to][_tokenId] = ownedNonSellableProducts[_from][_tokenId];
            delete(ownedNonSellableProducts[_from][_tokenId]);
            products[_tokenId].owner = _to;
        }
    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) override external payable {
        require(msg.sender == products[_tokenId].owner || addressToOperatorCheck[_from][_to] || productToApprovedAddress[_tokenId] == _to, "Permission denied");
        require(_to != address(0), "Cannot transfer to address 0");
        if (products[_tokenId].forSale) {
            buyProduct(_tokenId, _from, _to);
        }
        else {
            ownedNonSellableProducts[_to][_tokenId] = ownedNonSellableProducts[_from][_tokenId];
            delete(ownedNonSellableProducts[_from][_tokenId]);
            products[_tokenId].owner = _to;
        }
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) override external payable {
        require(msg.sender == products[_tokenId].owner || addressToOperatorCheck[_from][_to] || productToApprovedAddress[_tokenId] == _to, "Permission denied");
        require(_to != address(0), "Cannot transfer to address 0");
        if (products[_tokenId].forSale) {
            buyProduct(_tokenId, _from, _to);
        }
        else {
            ownedNonSellableProducts[_to][_tokenId] = ownedNonSellableProducts[_from][_tokenId];
            delete(ownedNonSellableProducts[_from][_tokenId]);
            products[_tokenId].owner = _to;
        }
    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) override external payable {
        require(msg.sender == products[_tokenId].owner);
        productToApprovedAddress[_tokenId] = _approved;
    }

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) override external {
        addressToOperatorCheck[msg.sender][_operator] = _approved;
    }

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) override external view returns (address) {
        return productToApprovedAddress[_tokenId];
    }

    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) override external view returns (bool) {
        return addressToOperatorCheck[_owner][_operator];
    }
}