import Testing
@testable import FlightFramework

struct FlightAPIRouteTests {
    @Test func testV1AirlinesListBuilder() throws {
        let builder = V1API.v1AirlinesListWithRequestBuilder(search: "Q", page: 1, limit: 2)
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/airlines/")
    }

    @Test func testV1AirportsListBuilder() throws {
        let builder = V1API.v1AirportsListWithRequestBuilder(search: "A", page: 1, limit: 3)
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/airports/")
    }

    @Test func testV1FcmTestCreateBuilder() throws {
        let builder = V1API.v1FcmTestCreateWithRequestBuilder()
        #expect(builder.method == "POST")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/fcm-test/")
    }

    @Test func testV1FlightsListBuilder() throws {
        let builder = V1API.v1FlightsListWithRequestBuilder(latitude: 0, longitude: 0, radius: 1, authorization: "auth")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/flights/")
    }

    @Test func testV1FlightsReadBuilder() throws {
        let builder = V1API.v1FlightsReadWithRequestBuilder(id: "ID", authorization: "auth")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/flights/ID/")
    }

    @Test func testV1SchedulesListBuilder() throws {
        let builder = V1API.v1SchedulesListWithRequestBuilder(authorization: "auth")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/schedules/")
    }

    @Test func testV1SchedulesReadBuilder() throws {
        let builder = V1API.v1SchedulesReadWithRequestBuilder(iataCode: "AA", authorization: "auth")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/schedules/AA/")
    }

    @Test func testV1SearchListBuilder() throws {
        let builder = V1API.v1SearchListWithRequestBuilder(search: "Q")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/search/")
    }

    @Test func testV1TestListBuilder() throws {
        let builder = V1API.v1TestListWithRequestBuilder()
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/test/")
    }

    @Test func testV1TestReadBuilder() throws {
        let builder = V1API.v1TestReadWithRequestBuilder(id: "1")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/test/1/")
    }

    @Test func testV1TimezonesListBuilder() throws {
        let builder = V1API.v1TimezonesListWithRequestBuilder()
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/timezones/")
    }

    @Test func testV1TrackCreateBuilder() throws {
        let model = AlertRequestModel()
        let builder = V1API.v1TrackCreateWithRequestBuilder(data: model)
        #expect(builder.method == "POST")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/track/")
    }

    @Test func testV1TrackDeleteBuilder() throws {
        let builder = V1API.v1TrackDeleteWithRequestBuilder(id: 1)
        #expect(builder.method == "DELETE")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/track/1/")
    }

    @Test func testV1TrackListBuilder() throws {
        let builder = V1API.v1TrackListWithRequestBuilder(user: "user")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/track/")
    }

    @Test func testV1UserCreateBuilder() throws {
        let user = User()
        let builder = V1API.v1UserCreateWithRequestBuilder(data: user)
        #expect(builder.method == "POST")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/user/")
    }

    @Test func testV1UserPartialUpdateBuilder() throws {
        let user = User()
        let builder = V1API.v1UserPartialUpdateWithRequestBuilder(userId: "1", data: user)
        #expect(builder.method == "PATCH")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/user/1/")
    }

    @Test func testV1UserUpdateBuilder() throws {
        let user = User()
        let builder = V1API.v1UserUpdateWithRequestBuilder(userId: "1", data: user)
        #expect(builder.method == "PUT")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v1/user/1/")
    }

    @Test func testV2FlightListBuilder() throws {
        let builder = V2API.v2FlightListWithRequestBuilder(airlineId: "AA", flightNumber: "1", date: "20200101", authorization: "auth")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v2/flight/")
    }

    @Test func testV2SchedulesListBuilder() throws {
        let builder = V2API.v2SchedulesListWithRequestBuilder(authorization: "auth")
        #expect(builder.method == "GET")
        #expect(builder.URLString == SwaggerClientAPI.basePath + "/v2/schedules/")
    }
}
