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

export default function ProductItem({
  product,
  onBuyProduct,
  loading,
  forSale,
}) {
  const [hover, setHover] = useState(true);

  return (
    <Card
      sx={{
        maxWidth: 345,
        background: "#082032",
        transition: "all .2s ease-in-out",
        boxShadow: "rgba(0, 0, 0, 0.1) 0px 4px 12px",
        "&:hover": {
          transform: "scale(1.02)",
          boxShadow: "rgba(255, 76, 41, 0.1) 0px 4px 12px",
        },
      }}
    >
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
      {forSale && (
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
      )}
    </Card>
  );
}
