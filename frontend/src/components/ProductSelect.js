import React from "react";
import { Autocomplete, TextField } from "@mui/material";

export default function ProductSelect({ products, onChange }) {
  return (
    <Autocomplete
      id="product-select"
      options={products}
      getOptionLabel={(option) => option.name}
      onChange={onChange}
      fullWidth
      renderInput={(params) => (
        <TextField
          {...params}
          required
          label="Owned Products"
          variant="standard"
        />
      )}
    />
  );
}
