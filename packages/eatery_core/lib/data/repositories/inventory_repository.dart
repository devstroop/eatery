import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

class InventoryRepository {
  final EateryStore _store;
  InventoryRepository(this._store);

  // ── Suppliers ──

  List<Supplier> getAllSuppliers() =>
      _store.query('SELECT * FROM supplier ORDER BY name')
          .map(Supplier.fromMap).toList();

  Supplier? getSupplierById(int id) {
    final rows = _store.query('SELECT * FROM supplier WHERE id = ?', [id]);
    return rows.isEmpty ? null : Supplier.fromMap(rows.first);
  }

  Future<int> saveSupplier(Supplier s) async {
    final m = s.toMap();
    if (s.id != null) {
      _store.execute(
        'UPDATE supplier SET name=?,contactName=?,phone=?,email=?,address=?,'
        'gstin=?,isActive=?,updatedAt=? WHERE id=?',
        [m['name'], m['contactName'], m['phone'], m['email'], m['address'],
         m['gstin'], m['isActive'], m['updatedAt'], s.id],
      );
      return s.id!;
    }
    _store.execute(
      'INSERT INTO supplier (name,contactName,phone,email,address,gstin,isActive,createdAt,updatedAt) '
      'VALUES (?,?,?,?,?,?,?,?,?)',
      [m['name'], m['contactName'], m['phone'], m['email'], m['address'],
       m['gstin'], m['isActive'], m['createdAt'], m['updatedAt']],
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    notifyMutation('supplier', id, 'save', s.copyWith(id: id).toMap());
    return id;
  }

  Future<void> deleteSupplier(int id) async {
    _store.execute('DELETE FROM supplier WHERE id = ?', [id]);
    notifyMutation('supplier', id, 'delete', {'id': id});
  }

  // ── Purchase Orders ──

  List<PurchaseOrder> getAllPurchaseOrders() =>
      _store.query('SELECT * FROM purchase_order ORDER BY id DESC')
          .map(PurchaseOrder.fromMap).toList();

  PurchaseOrder? getPurchaseOrderById(int id) {
    final rows = _store.query('SELECT * FROM purchase_order WHERE id = ?', [id]);
    return rows.isEmpty ? null : PurchaseOrder.fromMap(rows.first);
  }

  Future<int> savePurchaseOrder(PurchaseOrder po) async {
    final m = po.toMap();
    if (po.id != null) {
      _store.execute(
        'UPDATE purchase_order SET supplierId=?,orderDate=?,expectedDate=?,'
        'deliveredDate=?,status=?,totalAmount=?,notes=?,createdBy=?,updatedAt=? WHERE id=?',
        [m['supplierId'], m['orderDate'], m['expectedDate'], m['deliveredDate'],
         m['status'], m['totalAmount'], m['notes'], m['createdBy'], m['updatedAt'], po.id],
      );
      return po.id!;
    }
    _store.execute(
      'INSERT INTO purchase_order (supplierId,orderDate,expectedDate,deliveredDate,'
      'status,totalAmount,notes,createdBy,createdAt,updatedAt) VALUES (?,?,?,?,?,?,?,?,?,?)',
      [m['supplierId'], m['orderDate'], m['expectedDate'], m['deliveredDate'],
       m['status'], m['totalAmount'], m['notes'], m['createdBy'], m['createdAt'], m['updatedAt']],
    );
    return _store.queryScalar('SELECT last_insert_rowid()') as int;
  }

  List<PurchaseOrderItem> getPurchaseOrderItems(int poId) =>
      _store.query('SELECT * FROM purchase_order_item WHERE purchaseOrderId = ?', [poId])
          .map(PurchaseOrderItem.fromMap).toList();

  Future<void> savePurchaseOrderItem(PurchaseOrderItem item) async {
    final m = item.toMap();
    if (item.id != null) {
      _store.execute(
        'UPDATE purchase_order_item SET quantity=?,unitPrice=?,totalPrice=?,receivedQty=? WHERE id=?',
        [m['quantity'], m['unitPrice'], m['totalPrice'], m['receivedQty'], item.id],
      );
    } else {
      _store.execute(
        'INSERT INTO purchase_order_item (purchaseOrderId,productId,quantity,unitPrice,totalPrice,receivedQty) '
        'VALUES (?,?,?,?,?,?)',
        [m['purchaseOrderId'], m['productId'], m['quantity'], m['unitPrice'], m['totalPrice'], m['receivedQty']],
      );
    }
  }

  // ── Stock Adjustments ──

  List<StockAdjustment> getStockAdjustments(int productId) =>
      _store.query('SELECT * FROM stock_adjustment WHERE productId = ? ORDER BY createdAt', [productId])
          .map(StockAdjustment.fromMap).toList();

  Future<void> addStockAdjustment(StockAdjustment adj) async {
    final m = adj.toMap();
    _store.execute(
      'INSERT INTO stock_adjustment (productId,quantity,reason,referenceId,notes,createdBy,createdAt) '
      'VALUES (?,?,?,?,?,?,?)',
      [m['productId'], m['quantity'], m['reason'], m['referenceId'], m['notes'], m['createdBy'], m['createdAt']],
    );
    // Update product stock quantity
    _store.execute(
      'UPDATE product SET stockQuantity = COALESCE(stockQuantity, 0) + ? WHERE id = ?',
      [adj.quantity, adj.productId],
    );
  }
}
