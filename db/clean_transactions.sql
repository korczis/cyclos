/*
 * Cyclos 3.7 clean transactions script
 * --------------------------
 * 
 * WARNING!!!: Running this script over an existing Cyclos database will 
 * mercilessly delete  all transactions, loans, invoices, references and all related data,
 * leaving only the configuration, accounts and users. Be careful when you use it.
 */

/* Delete data*/
begin;
delete from reference_history;
delete from refs;
delete from custom_field_values where subclass = 'pmt';
update transfers set by_id = null, parent_id = null, transaction_fee_id = null, loan_payment_id = null, account_fee_log_id = null, fee_id = null, receiver_id = null, external_transfer_id = null, chargeback_of_id = null, chargedback_by_id = null;
update account_fees set enabled_since = current_date where enabled_since is not null;
delete from member_account_fee_logs;
delete from invoice_payments;
delete from invoices;
delete from account_rates;
delete from closed_account_balances;
delete from amount_reservations;
delete from account_limit_logs;
delete from account_fee_logs;
delete from external_transfers;
delete from loan_payments;
delete from members_loans;
delete from loans;
delete from tickets;
delete from transfer_authorizations;
delete from transfers;
delete from scheduled_payments;
commit;