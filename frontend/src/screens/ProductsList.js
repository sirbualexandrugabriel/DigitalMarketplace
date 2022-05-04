import React, { useState, useEffect, useCallback } from "react";
import { CircularProgress, Grid, Box, Typography } from "@mui/material";
import ProductItem from "../components/ProductItem";
import FilterSellingProducts from "../components/FilterSellingProducts";
import { useSnackbar } from "notistack";

export default function ProductsList({
  contract,
  forSale,
  userAccount,
  toggleNotify,
}) {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [pageLoading, setPageLoading] = useState(false);
  const [filterLoading, setFilterLoading] = useState(false);

  const { enqueueSnackbar } = useSnackbar();

  const populate = useCallback(() => {
    if (contract) {
      setPageLoading(true);
      if (forSale) {
        contract.methods
          .getAllProductsForSale(0, 50)
          .call()
          .then((result) => {
            Promise.all(
              result[1].map((product) =>
                contract.methods
                  .getSellableProductDetails(product.id)
                  .call()
                  .then((sellableProduct) => {
                    return { ...product, ...sellableProduct };
                  })
              )
            ).then((newProducts) => {
              setProducts(newProducts);
            });
            setPageLoading(false);
          });
      } else {
        contract.methods
          .getOwnerProducts(0, 50)
          .call()
          .then((result) => {
            setProducts(result[1]);
            setPageLoading(false);
          });
      }
    }
  }, [contract, forSale, toggleNotify]);

  useEffect(() => {
    populate();
  }, [populate]);

  const handleAlert = (variant, message) => {
    enqueueSnackbar(message, { variant });
  };

  const handleFilter = (filterCriteria, filterOption) => {
    if (contract) {
      setFilterLoading(true);
      contract.methods
        .filterSellingProducts(
          filterCriteria === "partialTitle" ? filterOption : "",
          filterCriteria === "category" ? filterOption : "",
          filterCriteria === "owner"
            ? filterOption
            : "0x0000000000000000000000000000000000000000",
          filterCriteria === "date"
            ? Math.floor(new Date(filterOption).getTime() / 1000)
            : 0,
          0,
          50
        )
        .call()
        .then((result) => {
          Promise.all(
            result[1]
              .filter(
                (product) =>
                  product.owner !== "0x0000000000000000000000000000000000000000"
              )
              .map((product) =>
                contract.methods
                  .getSellableProductDetails(product.id)
                  .call()
                  .then((sellableProduct) => {
                    return { ...product, ...sellableProduct };
                  })
              )
          ).then((newProducts) => {
            setProducts(newProducts);
            setFilterLoading(false);
          });
        })
        .catch((error) => {
          setFilterLoading(false);
        });
    }
  };

  const handleBuyProduct = (product, owner) => {
    if (contract) {
      setLoading(true);
      contract.methods
        .buyProduct(product.id, owner, userAccount)
        .estimateGas({
          value: parseInt(product.price) + parseInt(product.fees),
        })
        .then((gas) => {
          return contract.methods
            .buyProduct(product.id, owner, userAccount)
            .send({
              from: userAccount,
              gas,
              value: parseInt(product.price) + parseInt(product.fees),
            });
        })
        .then(() => {
          setLoading(false);
          populate();
          handleAlert("success", "Product Bought Successfully!");
        })
        .catch((error) => {
          setLoading(false);
          handleAlert("error", error);
        });
    }
  };

  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      {forSale && (
        <FilterSellingProducts
          onFilter={handleFilter}
          loading={filterLoading}
        />
      )}
      <Grid container p={3} spacing={3}>
        {pageLoading ? (
          <Box
            sx={{
              width: "100%",
              marginTop: "10px",
            }}
          >
            <CircularProgress />
          </Box>
        ) : products.length > 0 ? (
          products.map((product, index) => (
            <Grid key={index} item xs={12} md={6} lg={3}>
              <ProductItem
                product={product}
                onBuyProduct={handleBuyProduct}
                loading={loading}
                forSale={forSale}
              />
            </Grid>
          ))
        ) : (
          <Box
            sx={{
              width: "100%",
              marginTop: "10px",
            }}
          >
            <Typography variant="body2">NO CONTENT</Typography>
          </Box>
        )}
      </Grid>
    </Box>
  );
}
