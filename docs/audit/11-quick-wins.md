# Audit 11 — Quick Wins

Issues that can be fixed immediately without architectural changes.

| Ref | Description | File(s) | Est. Time | Severity Before |
|-----|-------------|---------|-----------|-----------------|
| Q1 | Fix login bypass: change `password == null \|\| text == password` to `password != null && text == password` | `login.page.dart:43` | 2 min | CRITICAL |
| Q2 | Remove dead QR code button and empty menu buttons | `pos.page.dart:180`, `orders.page.dart:77-81` | 5 min | LOW |
| Q3 | Change `dynamic order` to `Order order` in `_OrderCard` | `orders.page.dart:119` | 2 min | MEDIUM |
| Q4 | Change `dynamic customer` to `Customer customer` in `_CustomerCard` | `customers.page.dart:83` | 2 min | MEDIUM |
| Q5 | Change `dynamic staff` to `Staff staff` in `_StaffCard` | `staffs.page.dart:92` | 2 min | MEDIUM |
| Q6 | Add basic order items to ViewOrderPage — query `orderRepository.getOrderProducts(order.id)` and render | `view.order.page.dart:100-114` | 30 min | HIGH |
| Q7 | Fix table name display in ViewOrderPage — query dining table by orderId | `view.order.page.dart:52-55` | 10 min | HIGH |
| Q8 | Fix order status display in ViewOrderPage — show `order.status` instead of "NA" | `view.order.page.dart:64-66` | 2 min | HIGH |
| Q9 | Add `LIMIT 50` to `getAllOrders()` as a safety net against unbounded queries | `order_repository_sqlite.dart:33-34` | 5 min | MEDIUM |
| Q10 | Fix unsafe `as dynamic` cast in dining tables page — add `getAllCategories()` to interface or create separate provider | `dining.tables.page.dart:70-71`, `dining.table.repository.dart` | 20 min | CRITICAL |
| Q11 | Cache product list with local variable in kitchen dishes page to avoid redundant SQLite calls | `kitchen.dishes.page.dart:165,187-188` | 5 min | HIGH |
| Q12 | Cache customer list with local variable in customers page | `customers.page.dart:42-52` | 5 min | HIGH |
| Q13 | Fix payment validation: add `return;` after null order check | `add.payment.page.dart:207-211` | 1 min | LOW |
| Q14 | Remove or implement OrderConfirmationPage | `order.confirmation.page.dart` | 30 min | MEDIUM |
| Q15 | Add `return;` after AddPayment null order dialog to prevent fallthrough | `add.payment.page.dart:209` | 1 min | MEDIUM |
