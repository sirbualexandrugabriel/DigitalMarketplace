import React, { useState } from "react";
import {
  Box,
  Typography,
  AppBar,
  Tabs,
  Tab,
  Tooltip,
  Fab,
} from "@mui/material";
import ProductsList from "./ProductsList";
import SwipeableViews from "react-swipeable-views";
import AddIcon from "@mui/icons-material/Add";
import SellIcon from "@mui/icons-material/Sell";
import SellProduct from "../components/SellProduct";
import AddProduct from "../components/AddProduct";
import { useTheme } from "@mui/material/styles";
import { useSelector } from "react-redux";

function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`full-width-tabpanel-${index}`}
      aria-labelledby={`full-width-tab-${index}`}
      {...other}
    >
      {value === index && children}
    </div>
  );
}

function a11yProps(index) {
  return {
    id: `full-width-tab-${index}`,
    "aria-controls": `full-width-tabpanel-${index}`,
  };
}

export default function Layout({ contract }) {
  const [value, setValue] = useState(0);
  const [openSale, setOpenSale] = useState(false);
  const [openAdd, setOpenAdd] = useState(false);
  const [toggleNotify, setToggleNotify] = useState(false);

  const { userAccount } = useSelector((state) => state.userAccount);

  const theme = useTheme();

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const handleChangeIndex = (index) => {
    setValue(index);
  };

  return (
    <Box sx={{ width: "100%" }} pt={8}>
      <Tooltip arrow title="Sell Product" placement="left">
        <Fab
          color="primary"
          aria-label="add"
          sx={{ position: "fixed", right: 20, bottom: 20 }}
          onClick={() => setOpenSale(true)}
        >
          <SellIcon />
        </Fab>
      </Tooltip>
      <Tooltip arrow title="Add Product" placement="left">
        <Fab
          color="secondary"
          aria-label="add"
          sx={{ position: "fixed", right: 20, bottom: 90 }}
          onClick={() => setOpenAdd(true)}
        >
          <AddIcon />
        </Fab>
      </Tooltip>
      <SellProduct
        open={openSale}
        onClose={() => {
          setOpenSale(false);
          setToggleNotify(!toggleNotify);
        }}
        contract={contract}
      />
      <AddProduct
        open={openAdd}
        onClose={() => {
          setOpenAdd(false);
          setToggleNotify(!toggleNotify);
        }}
        contract={contract}
      />
      <AppBar position="fixed">
        <Tabs
          value={value}
          onChange={handleChange}
          indicatorColor="primary"
          textColor="primary"
          variant="fullWidth"
          aria-label="tabs"
        >
          <Tab label="FOR SALE" {...a11yProps(0)} />
          <Tab label="OWNED" {...a11yProps(1)} />
        </Tabs>
      </AppBar>
      <SwipeableViews
        axis={theme.direction === "rtl" ? "x-reverse" : "x"}
        index={value}
        onChangeIndex={handleChangeIndex}
      >
        <TabPanel value={value} index={0} dir={theme.direction}>
          <Typography variant="h5">PRODUCTS FOR SALE</Typography>
          <ProductsList
            contract={contract}
            forSale
            userAccount={userAccount}
            toggleNotify={toggleNotify}
          />
        </TabPanel>
        <TabPanel value={value} index={1} dir={theme.direction}>
          <Typography variant="h5">PRODUCTS OWNED</Typography>
          <ProductsList
            contract={contract}
            userAccount={userAccount}
            toggleNotify={toggleNotify}
          />
        </TabPanel>
      </SwipeableViews>
    </Box>
  );
}
