import React, { useState } from "react";
import {
  Card,
  Box,
  CardMedia,
  CardContent,
  Fab,
  Typography,
  Tooltip,
  CircularProgress,
} from "@mui/material";
import ShoppingCartIcon from "@mui/icons-material/ShoppingCart";

export default function ProductItem({ product, onBuyProduct, loading }) {
  const [hover, setHover] = useState(true);

  return (
    <Card sx={{ maxWidth: 345 }}>
      <CardMedia
        component="img"
        height="200"
        src={product.link}
        alt="No Image"
      />
      <CardContent>
        <Typography gutterBottom variant="h5" component="div">
          {product.name}
        </Typography>
        <Tooltip
          onOpen={() => setHover(false)}
          onClose={() => setHover(true)}
          title="Full product details"
        >
          <Typography variant="body2" color="text.secondary" noWrap={hover}>
            {product.description}
          </Typography>
        </Tooltip>
      </CardContent>
      <Box
        sx={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
        p={2}
      >
        <Typography color="primary" fontSize={24}>
          {parseInt(product.price) + parseInt(product.fees)} WEI
        </Typography>
        <Fab
          color="primary"
          disabled={loading}
          onClick={() => onBuyProduct(product, product.owner)}
        >
          {loading ? <CircularProgress /> : <ShoppingCartIcon />}
        </Fab>
      </Box>
    </Card>
  );
}
