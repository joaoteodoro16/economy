import '../../core/models/bill.dart';

abstract class BillRepository {

  Future<List<Bill>> getAll();
  Future<void> createBill({required Bill bill});
  Future<void> deleteById({required Bill bill});
  Future<void> updateBill({required Bill bill});
  Future<List<Bill>> getByDateFilter(DateTime startDate, DateTime endDate);



}