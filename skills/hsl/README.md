# HSL Journey Planner Skill

Query Helsinki Region Transport (HSL) public transit information using the Digitransit GraphQL API.

## Features

- 🚏 Find nearby stops
- 🚌 Get real-time departure information
- 🗺️ Plan trips between locations
- 🔍 Search for stops and routes by name
- 📍 Get stop and route details
- ⏱️ Real-time delay information

## Quick Setup

### 1. Get Your Free API Key

1. Visit https://portal-api.digitransit.fi/
2. Sign up/sign in (top right)
3. Verify your email
4. Set up 2FA
5. Create a subscription
6. Copy your API key

### 2. Add to OpenClaw

Edit your `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "hsl": {
        "enabled": true,
        "apiKey": "your-digitransit-subscription-key"
      }
    }
  }
}
```

### 3. Restart Gateway

```bash
docker compose restart openclaw-gateway
```

## Example Queries

Once enabled, you can ask OpenClaw:

- "When is the next tram from Kamppi?"
- "How do I get from Helsinki center to Espoo?"
- "What buses stop near Rautatientori?"
- "Show me tram route 9 stops"
- "Plan a trip from Railway Station to Otaniemi"

## API Documentation

Full API documentation is in `SKILL.md`.

## Testing

Test the API locally:

```bash
export DIGITRANSIT_SUBSCRIPTION_KEY="your-key"
./scripts/hsl-query.sh search-stops "Kamppi"
./scripts/hsl-query.sh nearby 60.199 24.938 500
```

## Resources

- API Portal: https://portal-api.digitransit.fi/
- Documentation: https://digitransit.fi/en/developers/
- GraphiQL Explorer: https://api.digitransit.fi/graphiql/hsl
- HSL Website: https://www.hsl.fi/en
