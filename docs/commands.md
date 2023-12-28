# Purpose of these queries is to test if models and systems working as expected without running the client



Spawn a new player from cli
```
sozo execute 0x1b4aead1d6c12b777951bbc9ddae7cea18d52a02cd9c14e41c176e995bc6997 spawn
```

Check if model exist
```graphql
query {
  model(id:"GameData") {
    id
    name
    classHash
  }
}
```


Fetch all the transactions

```grapqhl
query FetchTransactions{
  transactions{
    edges{
      node{
        id
        transactionHash
        senderAddress
        calldata
      }
    }
    totalCount
  }
}

```

Fetch GameData Model data
```graphql
query FetchGameDataModels{
  gamedataModels {
    edges {
      node {
        number_of_players
      }
    }
  }
}
```



Subscribe Score, RemainingMoves, Tile model changes

```graphql
subscription PlayerScoreSubscription {
 entityUpdated {
  id
  eventId
  models {
      __typename
      ... on Score {
        player_id
        score
      }
      ... on RemainingMoves {
        player_id
        moves
      }
    	... on Tile {
        player_id
        row
        col
        tile_type
        counted
      }
  }
}
}
```

Query Score and RemainingMoves

```graphql
query PlayerScore {
  scoreModels {
    edges {
      node {
        player_id
        score
      }
    }
  }
}

query PlayerRemainingMoves {
  remainingmovesModels {
    edges {
      node {
        player_id
        moves
      }
    }
  }
}
```