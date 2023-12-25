enum Roles {
  Admin,
  OrderView,
  OrderProduct,
  Receipt,
  ReceiptApprove,
  ReceiptPay,
  Guest,
}

const Map<String, Roles> rolesToDB = {
  "admin": Roles.Admin,
  "order.view": Roles.OrderView,
  "order.product": Roles.OrderProduct,
  "receipt": Roles.Receipt,
  "receipt.approve": Roles.ReceiptApprove,
  "receipt.pay": Roles.ReceiptPay,
};