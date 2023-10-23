class Location {
  String name;
  String address;
  double latitude;
  double longitude;
  double? distance;

  Location(this.name, this.address, this.latitude, this.longitude, [this.distance]);

  static List<Location> getLocations() {
    return [
      Location("UB Library", "Jl. Veteran, Ketawanggede",
          -7.9530095, 112.6134329),
      Location("Malang Town Square", "Lt.2, Jl. Veteran No.2, Penanggungan",
          -7.9569733, 112.6160176),
      Location("ITS Library", "Jl. ITS Raya, Sukolilo",
          -7.2816768, 112.7929673),
      Location("Galaxy Mall 2", "Lt.1, Jl. Dharmahusada Indah Timur No.35-37",
          -7.2746687, 112.7807733)
    ];
  }
}

