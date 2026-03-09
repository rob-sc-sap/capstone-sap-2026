namespace vendor.selection;

entity Products {
    key ID: Integer;
    name: String(45);
    category: String(45);
    safetyStockLevel: Double;
    tarriff: Association to one Tarriffs;
}

entity Tarriffs {
    key ID: Integer;
    currentTarriffRate: Double;
    effectiveDate: DateTime;
    expiringDate: DateTime;
    countryName: String;
    product: Association to many Products on product.tarriff = $self;
}