# HTF25 Documentation

This directory contains the VitePress documentation site for the Hack The Future 2025 serverless challenge.

## Development

1. Install dependencies (from the repository root):
   ```bash
   pnpm install
   ```

2. Start development server:
   ```bash
   pnpm run dev
   ```

3. Build for production:
   ```bash
   pnpm run build
   ```

## Deployment

The documentation is automatically deployed when pushing to the main branch.

## Content Structure

- **Overview**: Project introduction and architecture
- **Implementation**: Detailed guides for each level
- **Deployment**: Setup and configuration instructions
- **Innovation**: Advanced features and future work
- **Presentation**: Demo scripts and materials

## Contributing

1. Add new pages as `.md` files in the appropriate directory
2. Update the sidebar configuration in `.vitepress/config.js`
3. Use Mermaid diagrams for flowcharts and architecture
4. Test locally before committing
