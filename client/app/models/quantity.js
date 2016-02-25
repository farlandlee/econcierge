import Ember from 'ember';

export let amountForQuantity = function (amounts, quantity) {
  return amounts.find(({min_quantity, max_quantity}) => {
    return quantity >= min_quantity &&
    (max_quantity === 0 || quantity <= max_quantity);
  });
};

export default Ember.Object.extend({
  id: null,
  quantity: 0,
  cost: 0
});
