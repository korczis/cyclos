/*
 * Cyclos 3.6 clean up script
 * --------------------------
 * 
 * WARNING!!!: Running this script over an existing Cyclos database will 
 * mercilessly delete all users, transactions and all related data,
 * leaving only the configuration. Be careful when you use it.
 * The only user that will be left is the default 'admin'.
 *
 * WARNING 2: After running this script, also remove the WEB-INF/indexes
 * and WEB-INF/cache directories (if any) in order to prevent old data to be
 * retrieved from searches.
 */

/* Delete data*/
begin;
delete from brokering_commission_status;
delete from broker_commission_contracts;
delete from brokerings;
delete from contacts;
delete from reference_history;
delete from refs;
delete from ad_interests;
delete from notification_preferences;
delete from images where subclass in ('ad', 'mbr');
delete from custom_field_values where subclass <> ('admin');
delete from custom_field_values where admin_id <> 1;
delete from alerts;
delete from error_log_entry_parameters;
delete from error_log_entries;
delete from admin_preferences_member_alerts;
delete from admin_preferences_system_alerts;
delete from admin_preferences_new_members;
delete from admin_preferences_message_categories;
delete from admin_preferences_transfer_types;
delete from admin_preferences_new_pending_payments;
delete from admin_preferences_guarantee_types;
delete from admin_notification_preferences;
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
delete from payment_obligation_logs;
delete from payment_obligations;
delete from guarantee_logs;
delete from guarantees;
delete from certification_logs;
delete from certifications;
delete from loans;
delete from tickets;
delete from transfer_authorizations;
delete from transfers;
delete from scheduled_payments;
delete from accounts where subclass = 'M';
delete from operator_groups_max_amount;
delete from members_loan_groups;
delete from loan_groups;
delete from ads;
delete from login_history;
delete from remarks;
delete from default_broker_commissions;
delete from group_history_logs;
delete from password_history;
delete from username_change_logs;
delete from wrong_credential_attempts;
delete from permission_denieds;
delete from sessions;
delete from users where username not in ('admin');
delete from messages_to_groups;
delete from messages;
delete from print_settings;
update members set member_broker_id = null, member_id = null;
update groups set member_id = null;
delete from members_channels;
delete from member_records;
delete from pending_members;
delete from transaction_fees where from_member_id is not null or to_member_id is not null;
delete from custom_field_values where field_id in (select id from custom_fields where member_id is not null);
delete from custom_field_possible_values where field_id in (select id from custom_fields where member_id is not null);
delete from custom_fields where member_id is not null;
delete from documents where member_id is not null;
delete from registration_agreement_logs;
create table clients_to_remove select id from service_clients where member_id is not null;
delete from service_client_permissions where service_client_id in (select id from clients_to_remove);
delete from service_clients_receive_payment_types where service_client_id in (select id from clients_to_remove);
delete from service_clients_do_payment_types where service_client_id in (select id from clients_to_remove);
delete from service_clients_manage_groups where service_client_id in (select id from clients_to_remove);
delete from service_clients_chargeback_payment_types where service_client_id in (select id from clients_to_remove);
delete from service_clients where id in (select id from clients_to_remove);
drop table clients_to_remove;
delete from custom_field_values where field_id in (select id from custom_fields where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null));
delete from custom_field_possible_values where field_id in (select id from custom_fields where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null));
delete from custom_fields where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from transfer_types_channels where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from groups_chargeback_transfer_types where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from groups_transfer_types where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from groups_transfer_types_as_member where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from transfer_types_payment_filters where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from service_clients_receive_payment_types where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from service_clients_do_payment_types where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from service_clients_chargeback_payment_types where transfer_type_id in (select id from transfer_types where fixed_destination_member_id is not null);
delete from transfer_types where fixed_destination_member_id is not null;
update pos set member_pos_id = null;
delete from member_pos;
delete from pos_logs;
delete from pos;
delete from card_logs;
delete from cards;
delete from sms_logs;
delete from member_sms_status;
delete from sms_mailings_pending_to_send;
delete from sms_mailings_groups;
delete from sms_mailings;
delete from external_transfers;
delete from external_transfer_imports;
delete from members where id not in (select id from users);
delete from permissions where group_id in (select id from groups where subclass = 'O');
delete from groups_transfer_types where group_id in (select id from groups where subclass = 'O');
delete from files where group_id in (select id from groups where subclass = 'O');
delete from group_operator_account_information_permissions;
delete from groups where subclass = 'O'; 
delete from account_locks;
insert into account_locks select id from accounts;
commit;