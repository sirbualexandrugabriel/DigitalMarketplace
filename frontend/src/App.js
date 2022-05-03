import React, { useEffect, useState } from "react";
import Web3 from "web3";
import { ContractABI } from "./ContractABI";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import { SnackbarProvider } from "notistack";
import { Box } from "@mui/material";
import { useDispatch } from "react-redux";
import Layout from "./screens/Layout";
import { setUserAccount } from "./redux/UserAccount";
import "./App.css";

const darkTheme = createTheme({
  palette: {
    mode: "dark",
  },
});

const web3 = new Web3(new Web3.providers.HttpProvider("HTTP://127.0.0.1:8545"));
web3.eth.defaultAccount = web3.eth.accounts[0];

function App() {
  const [remixContract, setRemixContract] = useState(null);
  const dispatch = useDispatch();

  useEffect(() => {
    setRemixContract(
      new web3.eth.Contract(
        ContractABI,
        "0x874ef8BFE00d6f22eaaaDAF3175Ea3762dAd2aB2"
      )
    );
    dispatch(setUserAccount("0x4f344bbB1dB1e694b89475E8A391F07f93D5559D"));
  }, []);

  // const setData = async (e) => {
  //   e.preventDefault();
  //   const accounts = await window.ethereum.enable();
  //   const account = accounts[0];

  //   const gas = await RemixContract.methods.setMessage(message).estimateGas();
  //   const result = await RemixContract.methods
  //     .setMessage(message)
  //     .send({ from: account, gas });
  //   console.log(result);
  // };

  // const getDefaultData = async (e) => {
  //   RemixContract.methods.defaultMessage().call().then(console.log);
  // };

  return (
    <ThemeProvider theme={darkTheme}>
      <SnackbarProvider maxSnack={3}>
        <Box className="App">
          <Layout contract={remixContract} />
        </Box>
      </SnackbarProvider>
    </ThemeProvider>
  );
}

export default App;
