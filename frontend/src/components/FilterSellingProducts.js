import React, { useState } from "react";
import {
  FormControl,
  Select,
  MenuItem,
  InputLabel,
  Box,
  IconButton,
  TextField,
  CircularProgress,
} from "@mui/material";
import FilterListIcon from "@mui/icons-material/FilterList";

export default function FilterSellingProducts({ onFilter, loading }) {
  const [filterCriteria, setFilterCriteria] = useState("partialTitle");
  const [filterOption, setFilterOption] = useState("");

  return (
    <Box
      sx={{ display: "flex", justifyContent: "center", alignItems: "center" }}
    >
      <TextField
        label="Filter Option"
        variant="standard"
        type={filterCriteria === "date" ? "date" : "text"}
        InputLabelProps={{ shrink: true }}
        onBlur={(event) => setFilterOption(event.target.value)}
      />
      <IconButton
        color="primary"
        aria-label="filter-button"
        size="large"
        onClick={() => onFilter(filterCriteria, filterOption)}
      >
        {loading ? <CircularProgress /> : <FilterListIcon fontSize="inherit" />}
      </IconButton>
      <FormControl variant="standard" sx={{ m: 1, minWidth: 200 }}>
        <InputLabel id="criteria-label">Filter By</InputLabel>
        <Select
          labelId="criteria-label"
          id="criteria-select"
          value={filterCriteria}
          onChange={(event) => {
            setFilterCriteria(event.target.value);
          }}
          label="Filter By *"
        >
          <MenuItem value="partialTitle">Partial title</MenuItem>
          <MenuItem value="category">Category</MenuItem>
          <MenuItem value="owner">Owner</MenuItem>
          <MenuItem value="date">Date</MenuItem>
        </Select>
      </FormControl>
    </Box>
  );
}
