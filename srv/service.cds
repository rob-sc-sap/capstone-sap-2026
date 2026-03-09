using { vendor.selection as my } from '../db/schema';

service VendorSelectionService {

    entity Products as projection on my.Products;
    entity Tarriffs as projection on my.Tarriffs;
}