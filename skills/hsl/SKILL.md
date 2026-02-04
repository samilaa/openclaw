---
name: hsl
description: Query HSL (Helsinki Region Transport) public transit routes, stops, schedules, and plan trips using the Digitransit GraphQL API.
homepage: https://digitransit.fi/en/developers/apis/1-routing-api/
metadata:
  {
    "openclaw":
      {
        "emoji": "🚇",
        "requires": { "bins": ["curl", "jq"], "env": ["DIGITRANSIT_SUBSCRIPTION_KEY"] },
        "primaryEnv": "DIGITRANSIT_SUBSCRIPTION_KEY",
      },
  }
---

# HSL Journey Planner

Query Helsinki Region Transport (HSL) public transit using the Digitransit GraphQL API.

## Setup

### 1. Get Your Free API Key

1. Go to https://portal-api.digitransit.fi/
2. Sign up or sign in (top right corner)
3. Verify your email address
4. Set up two-factor authentication (email or app)
5. Create a subscription to get your API key
6. Copy your API key

### 2. Configure OpenClaw

Add your API key to the OpenClaw config:

```json
{
  "skills": {
    "entries": {
      "hsl": {
        "enabled": true,
        "apiKey": "your-digitransit-subscription-key-here"
      }
    }
  }
}
```

Or set environment variable:
```bash
export DIGITRANSIT_SUBSCRIPTION_KEY="your-key-here"
```

## API Endpoint

```
https://api.digitransit.fi/routing/v2/hsl/gtfs/v1
```

## Quick Start

All queries are GraphQL POST requests with the subscription key header:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -H 'digitransit-subscription-key: YOUR_KEY_HERE' \
  -d 'GRAPHQL_QUERY_HERE'
```

## Common Queries

### 1. Find Stops Nearby

Find stops within radius (in meters) of coordinates:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  stopsByRadius(lat: 60.199, lon: 24.938, radius: 500) {
    edges {
      node {
        stop {
          gtfsId
          name
          code
          lat
          lon
          patterns {
            route {
              shortName
              longName
              mode
            }
          }
        }
        distance
      }
    }
  }
}'
```

### 2. Get Stop Information

Query a specific stop by ID (format: `HSL:STOPCODE`):

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  stop(id: "HSL:1040129") {
    name
    code
    lat
    lon
    wheelchairBoarding
    vehicleMode
    patterns {
      route {
        shortName
        longName
        mode
      }
    }
  }
}'
```

### 3. Get Stop Departures (Real-time)

Get upcoming departures from a stop:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  stop(id: "HSL:1040129") {
    name
    stoptimesWithoutPatterns(numberOfDepartures: 10) {
      scheduledArrival
      realtimeArrival
      arrivalDelay
      scheduledDeparture
      realtimeDeparture
      departureDelay
      realtime
      realtimeState
      serviceDay
      headsign
      trip {
        route {
          shortName
          longName
          mode
        }
      }
    }
  }
}'
```

### 4. Plan a Trip

Plan a route from point A to point B:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  plan(
    from: {lat: 60.168992, lon: 24.932366}
    to: {lat: 60.175294, lon: 24.684855}
    numItineraries: 3
  ) {
    itineraries {
      walkDistance
      duration
      legs {
        startTime
        endTime
        mode
        duration
        realTime
        distance
        transitLeg
        route {
          shortName
          longName
        }
        from {
          name
          lat
          lon
        }
        to {
          name
          lat
          lon
        }
      }
    }
  }
}'
```

### 5. Search Routes by Name

Find routes by number/name:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  routes(name: "550") {
    gtfsId
    shortName
    longName
    mode
    patterns {
      code
      directionId
      name
      stops {
        name
      }
    }
  }
}'
```

### 6. Search Stops by Name

Find stops by name:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  stops(name: "Kamppi") {
    gtfsId
    name
    code
    lat
    lon
    patterns {
      route {
        shortName
        mode
      }
    }
  }
}'
```

### 7. Get Route Pattern Details

Get all stops for a specific route pattern:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  pattern(id: "HSL:1059:0:01") {
    name
    code
    directionId
    route {
      shortName
      longName
      mode
    }
    stops {
      gtfsId
      name
      code
      lat
      lon
    }
  }
}'
```

## Transport Modes

Available modes for filtering:
- `BUS`
- `TRAM`
- `RAIL` (trains)
- `SUBWAY`
- `FERRY`
- `WALK`
- `BICYCLE`

Example with mode filter:

```bash
curl -X POST 'https://api.digitransit.fi/routing/v2/hsl/gtfs/v1' \
  -H 'Content-Type: application/graphql' \
  -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
  -d '{
  routes(name: "9", transportModes: TRAM) {
    gtfsId
    shortName
    longName
    mode
  }
}'
```

## Trip Planning Options

The `plan` query supports many options:

```graphql
{
  plan(
    from: {lat: 60.168992, lon: 24.932366}
    to: {lat: 60.175294, lon: 24.684855}
    numItineraries: 3
    date: "2024-12-25"
    time: "10:00:00"
    arriveBy: false
    transportModes: [{mode: BUS}, {mode: TRAM}, {mode: SUBWAY}]
    walkReluctance: 2.0
    walkBoardCost: 600
    minTransferTime: 120
    wheelchair: false
  ) {
    itineraries {
      walkDistance
      duration
      startTime
      endTime
      legs {
        mode
        startTime
        endTime
        from { name lat lon }
        to { name lat lon }
        distance
        duration
        route { shortName longName }
        headsign
      }
    }
  }
}
```

## Tips for Using the API

### Time Format
- Times are in seconds since midnight (e.g., `36000` = 10:00 AM)
- Convert with: `date -d "@$(($(date +%s) - $(date -d "today 00:00:00" +%s) + TIME_SECONDS))" +%H:%M:%S`
- Or use `serviceDay` field (Unix timestamp of the service day at midnight)

### Stop IDs
- Format: `HSL:STOPCODE` (e.g., `HSL:1040129`)
- Stop codes are typically 7 digits
- You can find stop codes on HSL signs or via the stops query

### Coordinates
- Helsinki center: approximately `lat: 60.170, lon: 24.938`
- Railway station: `lat: 60.172, lon: 24.941`
- Espoo center: `lat: 60.205, lon: 24.656`
- Vantaa center: `lat: 60.294, lon: 25.041`

### Real-time Data
- `realtime: true` indicates real-time prediction available
- `realtimeState` values: `SCHEDULED`, `UPDATED`, `CANCELED`
- Delays are in seconds (positive = late, negative = early)

### Response Parsing
Use `jq` to parse JSON responses:

```bash
# Extract stop names
curl ... | jq '.data.stops[].name'

# Get next departures with delay info
curl ... | jq '.data.stop.stoptimesWithoutPatterns[] | "\(.headsign): \(.realtimeDeparture) (delay: \(.departureDelay)s)"'
```

## Common Use Cases

**"When is the next bus from Kamppi?"**
1. Search for Kamppi stop: `stops(name: "Kamppi")`
2. Get stop ID from results
3. Query `stoptimesWithoutPatterns` for that stop

**"How do I get from Helsinki center to Espoo?"**
Use the `plan` query with coordinates or stop IDs

**"What routes stop at this location?"**
1. Use `stopsByRadius` with your coordinates
2. Look at `patterns.route` for each stop

**"Is the tram running on time?"**
Query `stoptimesWithoutPatterns` and check `departureDelay` and `realtime` fields

## Testing Queries

Interactive testing: https://api.digitransit.fi/graphiql/hsl

## Notes

- No API key required (open data)
- All requests must use POST method
- Content-Type header is mandatory
- Times are in Europe/Helsinki timezone (EET/EEST)
- Real-time data has ~30 second update frequency
- Historical data available for past trips
- Wheelchair accessibility info included

## Error Handling

If query fails:
- Check JSON syntax (use a validator)
- Verify stop/route IDs exist
- Ensure coordinates are in Finland
- Check Content-Type header is set
- Confirm POST method is used

## External Resources

- GraphiQL Explorer: https://api.digitransit.fi/graphiql/hsl
- API Documentation: https://digitransit.fi/en/developers/apis/1-routing-api/
- Schema Reference: Available in GraphiQL
- HSL Journey Planner: https://www.hsl.fi/en
