# Solitaire Engine Interface

This phase extracts pure game state transitions from `InterfaceController` into non-UI types.

## Types

- `SolitaireGameState`
  - Holds mutable collections for core stacks:
    - `masterDeck`
    - `shuffleDeck`
    - `deckStack` (stock)
    - `deckFlip` (waste)
    - `deckFlipDiscard` (waste recycle)
    - `handArray` (tableau)
    - `discardArray` (foundation)

- `SolitaireGameEngine`
  - Pure transition methods (no WatchKit dependencies):
    - `moveCards:fromStack:toStack:orderPreserved:`
    - `moveCards:fromStack:toStack:dealStacked:`
    - `dealToStacksInState:`
    - `flipFromDeckInState:flipCardsNumber:`
    - `shuffleMasterDeckInState:`

## Integration contract

- Controller owns rendering, accessibility, and input handling.
- Engine mutates only model/state collections.
- Controller invokes render/save/accessibility updates around engine calls.

## Behavior notes

- Gameplay rules and control flow are preserved from legacy implementation.
- Engine methods are now callable from non-UI contexts for future testing and integrations.
