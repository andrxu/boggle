import React from 'react';
import Button from '@material-ui/core/Button';

const Square = (props) => (
  <Button variant="outlined" size="small" onClick={props.onClick}>
    {props.value}
  </Button>
);

export default Square;

