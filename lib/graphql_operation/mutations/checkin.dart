const String checkin = r'''
  mutation CheckIn($code: String) {
    action: checkIn(code: $code) {
      id
      person{
        name
      }
      pubPromoter{
        pub{
          name
        }
      }
      checkinDateTime
      reservationDate
      code
    }
  }
''';
