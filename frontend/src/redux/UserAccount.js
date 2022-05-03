import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  userAccount: "",
};

export const userAccountSlice = createSlice({
  name: "userAccount",
  initialState,
  reducers: {
    setUserAccount: (state, action) => {
      return { ...state, userAccount: action.payload };
    },
  },
});

export const { setUserAccount } = userAccountSlice.actions;

export default userAccountSlice.reducer;
