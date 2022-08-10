/*
Charter class to create the contents of a charter objects
 */
class Charter {
  String? charterId;
  String? startDate;
  String? statusId;
  String? boatId;
  String? nights;
  String? itinerary;
  String? embarkment;
  String? disembarkment;
  String? destination;

  Charter(
    String charterId,
    String startDate,
    String statusId,
    String boatId,
    String nights,
    String itinerary,
    String embarkment,
    String disembarkment,
    String destination,
  ) {
    //default constructor
    this.charterId = charterId;
    this.startDate = startDate;
    this.statusId = statusId;
    this.boatId = boatId;
    this.nights = nights;
    this.itinerary = itinerary;
    this.embarkment = embarkment;
    this.disembarkment = disembarkment;
    this.destination = destination;
  }


  Map<String, dynamic> toMap() {
    //create a map object from charter object
    return {
      'charterId' : charterId,
      'startDate' : startDate,
      'statusId' : statusId,
      'boatId' : boatId,
      'nights' : nights,
      'itinerary' : itinerary,
      'embarkment' : embarkment,
      'disembarkment' : disembarkment,
      'destination' : destination,
    };
  }
}
