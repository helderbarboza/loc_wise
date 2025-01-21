# LocWise

LocWise is a solution for managing locations with integration to the IBGE API, that helps to manage data for municipalities and states. The system can import data from IBGE for accurate and up-to-date information.

## Features

- Authentication and Authorization using token-based login
- IBGE API Integration
  - Fetch detailed information about municipalities and states from the IBGE public API
  - Get detailed data about municipalities: population, GDP, territorial area and demographic density
- User-friendly Interface with attractive and responsive UI

## Getting Started

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/helderbarboza/loc_wise.git
   cd loc_wise
   ```

2. Install dependencies:
   ```sh
   mix deps.get
   ```

### Running the Application

1. Start the server:
   ```sh
   mix phx.server
   ```

2. Access the application at `http://localhost:4000`.

### Running Tests

1. Run the tests:
   ```sh
   mix test
   ```

## Acknowledgements

- [IBGE API](https://servicodados.ibge.gov.br/api/docs/) for providing the locations data.
- [IBGE Sidra](https://sidra.ibge.gov.br/) for providing the statistics data.
