#!/bin/bash
# HSL API Query Helper Script
# Requires: DIGITRANSIT_SUBSCRIPTION_KEY environment variable

set -euo pipefail

API_URL="https://api.digitransit.fi/routing/v2/hsl/gtfs/v1"

if [ -z "${DIGITRANSIT_SUBSCRIPTION_KEY:-}" ]; then
    echo "Error: DIGITRANSIT_SUBSCRIPTION_KEY environment variable not set"
    echo "Get your free key at: https://portal-api.digitransit.fi/"
    exit 1
fi

function query_graphql() {
    local query="$1"
    curl -s -X POST "$API_URL" \
        -H 'Content-Type: application/graphql' \
        -H "digitransit-subscription-key: $DIGITRANSIT_SUBSCRIPTION_KEY" \
        -d "$query"
}

function stops_nearby() {
    local lat="$1"
    local lon="$2"
    local radius="${3:-500}"

    query_graphql "{
  stopsByRadius(lat: $lat, lon: $lon, radius: $radius) {
    edges {
      node {
        stop {
          gtfsId
          name
          code
        }
        distance
      }
    }
  }
}"
}

function search_stops() {
    local name="$1"

    query_graphql "{
  stops(name: \"$name\") {
    gtfsId
    name
    code
    lat
    lon
  }
}"
}

case "${1:-}" in
    nearby)
        stops_nearby "${2:-60.170}" "${3:-24.938}" "${4:-500}"
        ;;
    search-stops)
        search_stops "$2"
        ;;
    *)
        echo "HSL API Query Helper"
        echo ""
        echo "Setup:"
        echo "  export DIGITRANSIT_SUBSCRIPTION_KEY='your-key-here'"
        echo "  Get your key at: https://portal-api.digitransit.fi/"
        echo ""
        echo "Usage:"
        echo "  $0 nearby [lat] [lon] [radius]"
        echo "  $0 search-stops <name>"
        echo ""
        echo "Examples:"
        echo "  $0 nearby                  # Stops near Helsinki center"
        echo "  $0 search-stops Kamppi     # Find Kamppi stops"
        exit 1
        ;;
esac
