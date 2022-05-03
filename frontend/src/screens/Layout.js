import React, { useState } from "react";
import { Box, Fab, Tooltip } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import SellIcon from "@mui/icons-material/Sell";
import ProductsList from "./ProductsList";
import SellProduct from "../components/SellProduct";

export default function Layout({ contract }) {
  const [openSale, setOpenSale] = useState(false);

  const handleSaleClick = () => {
    setOpenSale(true);
  };

  return (
    <Box sx={{ position: "relative", width: "100vw", height: "100vh" }}>
      <Tooltip arrow title="Sell Product" placement="left">
        <Fab
          color="primary"
          aria-label="add"
          sx={{ position: "absolute", right: 20, bottom: 20 }}
          onClick={handleSaleClick}
        >
          <SellIcon />
        </Fab>
      </Tooltip>
      <Tooltip arrow title="Add Product" placement="left">
        <Fab
          color="secondary"
          aria-label="add"
          sx={{ position: "absolute", right: 20, bottom: 90 }}
        >
          <AddIcon />
        </Fab>
      </Tooltip>
      <SellProduct
        open={openSale}
        onClose={() => setOpenSale(false)}
        contract={contract}
      />
      <ProductsList contract={contract} />
    </Box>
  );
}
