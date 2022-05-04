import React, { useEffect, useState } from "react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Button,
  IconButton,
  Tooltip,
  Box,
  Autocomplete,
  Checkbox,
  CircularProgress,
} from "@mui/material";
import AddCircleOutlineIcon from "@mui/icons-material/AddCircleOutline";
import CheckCircleOutlineIcon from "@mui/icons-material/CheckCircleOutline";
import CheckBoxOutlineBlankIcon from "@mui/icons-material/CheckBoxOutlineBlank";
import CheckBoxIcon from "@mui/icons-material/CheckBox";
import NumberFormat from "react-number-format";
import ProductSelect from "./ProductSelect";
import { categories } from "../utils";
import { useSelector } from "react-redux";
import { useSnackbar } from "notistack";

export default function SellProduct({ open, onClose, contract }) {
  // true - sell existing product; false - sell new product
  const [switchState, setSwitchState] = useState(true);
  const [newProduct, setNewProduct] = useState(null);
  const [ownedProducts, setOwnedProducts] = useState([]);
  const [loading, setLoading] = useState(false);

  const { userAccount } = useSelector((state) => state.userAccount);
  const { enqueueSnackbar } = useSnackbar();

  useEffect(() => {
    if (contract) {
      contract.methods
        .getOwnerProducts(0, 50)
        .call()
        .then((result) => {
          setOwnedProducts(result[1].filter((product) => !product.forSale));
        });
    }
  }, [contract, open]);

  const handleAlert = (variant, message) => {
    enqueueSnackbar(message, { variant });
  };

  const checkProduct = () => {
    if (!newProduct) return false;
    if (!newProduct.name) return false;
    if (!newProduct.description) return false;
    if (!newProduct.imageLink) return false;
    if (!newProduct.categories) return false;
    if (!newProduct.price) return false;
    return true;
  };

  const handleSellProduct = () => {
    if (contract) {
      if (switchState) {
        if (checkProduct()) {
          setLoading(true);
          contract.methods
            .listProductForSale(
              newProduct.name,
              newProduct.description,
              newProduct.imageLink,
              newProduct.categories,
              newProduct.price
            )
            .estimateGas()
            .then((gas) => {
              return contract.methods
                .listProductForSale(
                  newProduct.name,
                  newProduct.description,
                  newProduct.imageLink,
                  newProduct.categories,
                  newProduct.price
                )
                .send({ from: userAccount, gas });
            })
            .then(() => {
              setLoading(false);
              handleAlert("success", "Product Listed For Sale!");
              onClose();
            })
            .catch((error) => {
              setLoading(false);
              handleAlert("error", error);
            });
        } else {
          handleAlert("error", "Make Sure All Field Are Completed!");
        }
      } else {
        if (!!newProduct.price) {
          setLoading(true);
          contract.methods
            .listExistingProductForSale(newProduct.productId, newProduct.price)
            .estimateGas()
            .then((gas) => {
              return contract.methods
                .listExistingProductForSale(
                  newProduct.productId,
                  newProduct.price
                )
                .send({ from: userAccount, gas });
            })
            .then(() => {
              setLoading(false);
              handleAlert("success", "Product Listed For Sale!");
              onClose();
            })
            .catch((error) => {
              setLoading(false);
              handleAlert("error", error);
            });
        }
      }
    }
  };

  return (
    <Dialog open={open} onClose={onClose}>
      <Box
        sx={{
          width: "100%",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <DialogTitle>SELL PRODUCT</DialogTitle>
        <Tooltip
          arrow
          placement="bottom"
          title={switchState ? "Sell Existing Product" : "Sell New Product"}
        >
          <IconButton
            onClick={() => setSwitchState(!switchState)}
            size="large"
            color="primary"
          >
            {switchState ? (
              <AddCircleOutlineIcon fontSize="inherit" />
            ) : (
              <CheckCircleOutlineIcon fontSize="inherit" />
            )}
          </IconButton>
        </Tooltip>
      </Box>
      <DialogContent>
        {switchState ? (
          <Box>
            <TextField
              autoFocus
              margin="dense"
              id="name"
              label="Name"
              fullWidth
              required
              variant="standard"
              onBlur={(event) =>
                setNewProduct({ ...newProduct, name: event.target.value })
              }
            />
            <TextField
              margin="dense"
              id="description"
              label="Description"
              multiline
              fullWidth
              required
              variant="standard"
              onBlur={(event) =>
                setNewProduct({
                  ...newProduct,
                  description: event.target.value,
                })
              }
            />
            <TextField
              margin="dense"
              id="image-link"
              label="Image Link"
              fullWidth
              required
              variant="standard"
              onBlur={(event) =>
                setNewProduct({ ...newProduct, imageLink: event.target.value })
              }
            />
            <Autocomplete
              multiple
              id="categories"
              options={categories}
              disableCloseOnSelect
              getOptionLabel={(option) => option}
              renderOption={(props, option, { selected }) => (
                <li {...props}>
                  <Checkbox
                    icon={<CheckBoxOutlineBlankIcon fontSize="small" />}
                    checkedIcon={<CheckBoxIcon fontSize="small" />}
                    style={{ marginRight: 8 }}
                    checked={selected}
                  />
                  {option}
                </li>
              )}
              fullWidth
              renderInput={(params) => (
                <TextField
                  {...params}
                  label="Categories"
                  placeholder="Tags"
                  variant="standard"
                  margin="dense"
                  required
                />
              )}
              onChange={(event, values) => {
                setNewProduct({ ...newProduct, categories: values });
              }}
            />
          </Box>
        ) : (
          <ProductSelect
            products={ownedProducts}
            onChange={(event, newValue) => {
              setNewProduct({
                ...newProduct,
                productId: parseInt(newValue.id),
              });
            }}
          />
        )}
        <NumberFormat
          customInput={TextField}
          fullWidth
          margin="dense"
          label="Price"
          variant="standard"
          onValueChange={(values) =>
            setNewProduct({ ...newProduct, price: values.floatValue })
          }
          value={setNewProduct.price}
          thousandSeparator
          decimalSeparator={false}
          allowNegative={false}
          suffix=" WEI"
          required
        />
      </DialogContent>
      <DialogActions>
        {loading && <CircularProgress />}
        <Button onClick={onClose} disabled={loading}>
          Cancel
        </Button>
        <Button
          onClick={handleSellProduct}
          variant="contained"
          disabled={loading}
          sx={{ marginRight: "20px", marginBottom: "10px" }}
        >
          Sell
        </Button>
      </DialogActions>
    </Dialog>
  );
}
