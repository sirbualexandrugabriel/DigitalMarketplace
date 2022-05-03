import React, { useState, useEffect } from "react";
import { Grid } from "@mui/material";
import ProductItem from "../components/ProductItem";
import { useSelector } from "react-redux";
import { useSnackbar } from "notistack";

export default function ProductsList({ contract }) {
  const [productsForSale, setProductsForSale] = useState([]);
  const [lastIndex, setLastIndex] = useState(0);
  const [loading, setLoading] = useState(false);

  const { userAccount } = useSelector((state) => state.userAccount);
  const { enqueueSnackbar } = useSnackbar();

  useEffect(() => {
    if (contract) {
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
            setProductsForSale(newProducts);
          });

          setLastIndex(result[0]);
        });
    }
  }, [contract]);

  const handleAlert = (variant, message) => {
    enqueueSnackbar(message, { variant });
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
          handleAlert("success", "Product Bought Successfully!");
        })
        .catch((error) => {
          setLoading(false);
          handleAlert("error", error);
        });
    }
  };

  //   console.log(productsForSale);

  return (
    <Grid container p={3}>
      {productsForSale.map((product, index) => (
        <Grid key={index} item xs={12} md={6} lg={4}>
          <ProductItem
            product={product}
            onBuyProduct={handleBuyProduct}
            loading={loading}
          />
        </Grid>
      ))}
    </Grid>
  );
}
