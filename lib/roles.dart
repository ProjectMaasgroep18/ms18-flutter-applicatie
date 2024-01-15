enum Roles {
  Admin,
  Order,
  OrderView,
  OrderProduct,
  Receipt,
  ReceiptApprove,
  ReceiptPay,
  CalendarEditor
}

const Map<String, Roles> rolesToDB = {
  "admin": Roles.Admin,
  "order": Roles.Order,
  "order.view": Roles.OrderView,
  "order.product": Roles.OrderProduct,
  "receipt": Roles.Receipt,
  "receipt.approve": Roles.ReceiptApprove,
  "receipt.pay": Roles.ReceiptPay,
  "calendar.editor": Roles.CalendarEditor,
};

const Map<String, Roles> rolesDescription = {
  "Toegang tot alles": Roles.Admin,
  "Bestellingen aanmaken": Roles.Order,
  "Bestellingen bekijken": Roles.OrderView,
  "Bestellingen product": Roles.OrderProduct,
  "Declaraties aanmaken": Roles.Receipt,
  "Declaraties goedkeuren": Roles.ReceiptApprove,
  "Declaraties betalen": Roles.ReceiptPay,
  "Agenda items bewerken": Roles.CalendarEditor,
};
