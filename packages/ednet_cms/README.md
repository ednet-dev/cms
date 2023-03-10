[![Codemagic build status](https://api.codemagic.io/apps/63ce7b5ab80ead4e2c0f4735/ci/status_badge.svg)](https://codemagic.io/apps/63ce7b5ab80ead4e2c0f4735/ci/latest_build)
[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

# EDNet.dev
Content Managed System domain model implementation in Dart and Flutter for use as first brick in development of multiplatform, complex, highly web integrated, business rich MVPs.

# Content
Content is omnipresent, recursive and self defined.
This does not make it easier to model it. Such artifact is hard to spot and catch its characteristic properties, as humans do with air, tend to take things for granted.
However, taking content for granted results in epidemic of bad UI, UX of trivial systems which are complicating analog-digital transition of intrinsic complex human processes.

Main motivation in developing this library is to answer those challenges by modeling Content primarily in function of User and Context in which User operates on Content.
Strategy is to elevate abstraction level above current web landscape, take some structured knowledge DB and map Semantic roles of Content across User Contexts and from there define particular implementations of Content-User-Context interactions ready to be specialized for particular instance of Context.

As those interactions are graphs we could take advantage of graph theory for further analysis and optimization, also rendering and intuitive interactive presentation.

## Principles
Before we continue we shall define context in which we are going to analyze domain model of Content by defining basic principles:

- **Human biology**: the human biology influences the sensory apparatus and therefore the types of content that can be consumed. This should be taken into account when defining the content types in the system.

- **Human psychology**: The cognitive abilities and psychology of humans should also be considered when designing the content management system. For example, the way information is presented and the layout of the user interface should be designed in a way that is easy for users to understand and navigate.

- **Digital product limitations**: The limitations of a digital product should also be considered when designing the content management system. For example, the types of media that can be handled by the system and the way that the content is stored and retrieved.

## Categorization
Following basic principles, we can make initial categorization of Content-Sensory-Context landscape (There will be a lot of silly examples necessary to demonstrate idea):

| Visual | Auditory | Olfactory | Gustatory | Tactile |
|---|---|---|---|---|
| TV | Speakers | Scent diffusers | Blender | Video game controller |
| Monitor | Headphones | Scented candles | Oven | Keyboard |
| Projector | Earbuds | Aromatherapy diffusers | Microwave | Mouse |
| Watch | Smart speaker | Scented room sprays | Slow cooker | Touchscreen |
| Refrigerator LCD panel | Car Audio System | Scented sachets | Instant Pot | Haptic feedback devices |
| Smartphone | Home Theater System | Air fresheners | Electric grill | Touch screen monitors |
| Tablet | Hearing aids |  | Food processors | Smartwatch |
| E-Book-Reader | Music players |  | Juicers | Smart home devices |
| Head-mounted display | Portable radios |  | Electric kettles | Remote controls |
| Virtual reality headset | Soundbars |  | Coffee makers | Game Pad |
| Augmented reality headset | Bluetooth speakers |  | Toasters |  |
| Digital photo frame |  |  |  |  |
| Digital signage |  |  |  |  |
| Smart glasses |  |  |  |  |


# Method

- Opinionated abstractions:
    - Language
    - Process
        - Event storming
            - Artifacts
                - Documentation
                    - Live
                    - Collaborative
                    - Gathering point like evening fire in old times
                - Software design - transpilable inside ECMAScript
                    - Domain driven design
                        - Domain
                            - Application
                                - Service
                            - Model
                                - Aggregate root
                                    - Entity children
                                    - Commands
                                    - Policies
                                    - Events
                                    - Roles
                                        - Permissions
                            - Infrastructure
                                - Repository
                                    - Destructive
                                    - None destructive
                                        - Event sourced
                        - Clients - other Bounded contexts depending on the implementation
                        - Dependencies - other Bounded contexts implementation depends on

By using such opinionated processes and somewhat structuring expected output artifacts enables us to generate
considerable amount of initial code on such way that we promote best practices across various verticals like:
- requirements gathering
- architecture
- software design
- testing
- implementation
- CI/CD