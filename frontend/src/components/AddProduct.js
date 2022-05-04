import React, { useState } from "react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Button,
  Autocomplete,
  Checkbox,
  CircularProgress,
} from "@mui/material";
import CheckBoxOutlineBlankIcon from "@mui/icons-material/CheckBoxOutlineBlank";
import CheckBoxIcon from "@mui/icons-material/CheckBox";
import { categories } from "../utils";
import { useSelector } from "react-redux";
import { useSnackbar } from "notistack";

export default function AddProduct({ open, onClose, contract }) {
  const [newProduct, setNewProduct] = useState(null);
  const [loading, setLoading] = useState(false);

  const { userAccount } = useSelector((state) => state.userAccount);
  const { enqueueSnackbar } = useSnackbar();

  const handleAlert = (variant, message) => {
    enqueueSnackbar(message, { variant });
  };

  const checkProduct = () => {
    if (!newProduct) return false;
    if (!newProduct.name) return false;
    if (!newProduct.description) return false;
    if (!newProduct.imageLink) return false;
    if (!newProduct.categories) return false;
    return true;
  };

  const handleAddProduct = () => {
    if (contract) {
      if (checkProduct()) {
        setLoading(true);
        contract.methods
          .addNonSellableProduct(
            newProduct.name,
            newProduct.description,
            newProduct.imageLink,
            newProduct.categories
          )
          .estimateGas()
          .then((gas) => {
            return contract.methods
              .addNonSellableProduct(
                newProduct.name,
                newProduct.description,
                newProduct.imageLink,
                newProduct.categories
              )
              .send({ from: userAccount, gas });
          })
          .then(() => {
            setLoading(false);
            handleAlert("success", "Product Added!");
            onClose();
          })
          .catch((error) => {
            setLoading(false);
            handleAlert("error", error);
          });
      } else {
        handleAlert("error", "Make Sure All Field Are Completed!");
      }
    }
  };

  return (
    <Dialog open={open} onClose={onClose}>
      <DialogTitle>ADD PRODUCT</DialogTitle>
      <DialogContent>
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
            setNewProduct({ ...newProduct, description: event.target.value })
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
      </DialogContent>
      <DialogActions>
        {loading && <CircularProgress />}
        <Button onClick={onClose} disabled={loading}>
          Cancel
        </Button>
        <Button
          onClick={handleAddProduct}
          variant="contained"
          disabled={loading}
        >
          Add
        </Button>
      </DialogActions>
    </Dialog>
  );
}
