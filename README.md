# Adrez POC - dbt Project

This repository contains the dbt (data build tool) project for the Adrez POC data pipeline.

## Project Structure

```
dbt/
├── adrez_dbt/
│   └── adrez_poc/          # Main dbt project
│       ├── models/         # Data transformation models
│       ├── macros/         # Reusable SQL macros
│       ├── tests/          # Custom data tests
│       ├── seeds/          # Static data files
│       ├── snapshots/      # Type 2 SCD snapshots
│       ├── analyses/       # Ad-hoc analyses
│       ├── dbt_project.yml # Project configuration
│       └── README.md       # Project documentation
└── README.md              # This file
```

## Prerequisites

- Python 3.8+
- dbt Core or dbt Cloud
- Access to Azure Data Lake Storage

## Installation

1. Clone this repository:
```bash
git clone <your-github-repo-url>
cd dbt
```

2. Install dbt dependencies:
```bash
pip install dbt-core
pip install dbt-sqlserver  # or appropriate adapter
```

3. Configure your database connection in `profiles.yml`

## Usage

1. Test the connection:
```bash
dbt debug
```

2. Run the models:
```bash
dbt run
```

3. Run tests:
```bash
dbt test
```

4. Generate documentation:
```bash
dbt docs generate
dbt docs serve
```

## Models

- `my_first_model.sql` - Basic transformation model
- `filtered_users.sql` - User filtering logic
- `models/example/` - Example models for reference

## Contributing

1. Create a feature branch
2. Make your changes
3. Add tests for new models
4. Submit a pull request

## License

[Add your license information here] 