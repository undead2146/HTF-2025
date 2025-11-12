import { defineConfig } from 'vitepress'
import { withMermaid } from 'vitepress-plugin-mermaid'

export default withMermaid(
    defineConfig({
        title: 'HackTheFuture',
        description: 'The serverless quest beneath the surface',
        base: '/HTF-2025',

        ignoreDeadLinks: true,

        head: [
            ['link', { rel: 'icon', href: '/assets/icon.svg' }]
        ],

        themeConfig: {
            logo: './assets/icon.svg',

            nav: [
                { text: 'Home', link: '/' }
            ],

            sidebar: [
                {
                    text: 'Overview',
                    items: [
                        { text: 'Home', link: '/' },
                        { text: 'Architecture Overview', link: '/architecture/overview' },
                        { text: 'Event Flow Diagrams', link: '/architecture/event-flow' },
                        { text: 'AWS Services Guide', link: '/architecture/aws-services' }
                    ]
                },
                {
                    text: 'Implementation',
                    items: [
                        { text: 'Level 1: Signal Classifier', link: '/implementation/level-1' },
                        { text: 'Level 2/3: Observation Ingest', link: '/implementation/level-2-3' },
                        { text: 'Level 4: Dark Signal Decipherer', link: '/implementation/level-4' },
                        { text: 'Level 5: Message Translator', link: '/implementation/level-5' }
                    ]
                },
                {
                    text: 'Deployment',
                    items: [
                        { text: 'Environment Setup', link: '/deployment/setup' },
                        { text: 'Configuration & Deployment', link: '/deployment/configuration' },
                        { text: 'Troubleshooting', link: '/deployment/troubleshooting' }
                    ]
                },
                {
                    text: 'Innovation',
                    items: [
                        { text: 'Features', link: '/innovation/features' },
                        { text: 'Future Work', link: '/innovation/future-work' }
                    ]
                },
                {
                    text: 'Presentation',
                    items: [
                        { text: '🎤 Presentation Guide', link: '/presentation/presentation-guide' },
                    ]
                }
            ],

            socialLinks: [
                { icon: 'github', link: 'https://github.com/undead2146/HTF-2025' }
            ],

            footer: {
                message: 'HackTheFuture 2025 Challenge 107',
                copyright: '© 2025 undead2146'
            }
        },

        // Mermaid configuration
        mermaid: {
            theme: 'default',
            themeVariables: {
                primaryColor: '#7c3aed',
                primaryTextColor: '#fff',
                primaryBorderColor: '#6b46c1',
                lineColor: '#5f5f5f',
                secondaryColor: '#2ed573',
                tertiaryColor: '#1e90ff'
            }
        },

        // Optional: Configure mermaid for dark mode
        mermaidPlugin: {
            class: 'mermaid my-class'
        }
    }),

    // Mermaid configuration
    {
        theme: 'default'
    }
)
