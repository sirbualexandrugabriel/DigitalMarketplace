import React, { useEffect, useState } from "react";
import Web3 from "web3";
import { ContractABI } from "./ContractABI";
import { ThemeProvider, createTheme } from "@mui/material/styles";
import { SnackbarProvider } from "notistack";
import { Box } from "@mui/material";
import { useDispatch } from "react-redux";
import Layout from "./screens/Layout";
import { setUserAccount } from "./redux/UserAccount";
import "./app.css";

const darkTheme = createTheme({
  palette: {
    mode: "dark",
    primary: { main: "#FF4C29" },
    secondary: { main: "#334756" },
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
        "0x94F897DE712ab38CD245F076d9fc31D822793E1E"
      )
    );
    dispatch(setUserAccount("0xefCA89D33587714F8F74Dc04eC71F17494885416"));
  }, [dispatch]);

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
        <Box
          sx={{
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            textAlign: "center",
          }}
        >
          <Layout contract={remixContract} />
        </Box>
      </SnackbarProvider>
    </ThemeProvider>
  );
}

export default App;
