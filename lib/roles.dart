enum Roles {
  Admin,
  Order,
  OrderView,
  OrderProduct,
  Receipt,
  ReceiptApprove,
  ReceiptPay,
}

const Map<String, Roles> rolesToDB = {
  "admin": Roles.Admin,
  "order": Roles.Order,
  "order.view": Roles.OrderView,
  "order.product": Roles.OrderProduct,
  "receipt": Roles.Receipt,
  "receipt.approve": Roles.ReceiptApprove,
  "receipt.pay": Roles.ReceiptPay,
};