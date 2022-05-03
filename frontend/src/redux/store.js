import { configureStore } from "@reduxjs/toolkit";
import userAccountReducer from "./UserAccount";

export const store = configureStore({
  reducer: { userAccount: userAccountReducer },
});
