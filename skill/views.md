# View Type Catalog

> All view types for expressing software, their cross-domain applicability, and when to use each.
>
> This document underpins the product's core architectural decision: **view schema is cross-domain shared, convention is domain-bound** (LLVM model).

---

## 1. Core Insight

Over decades of software engineering, the ways humans "express a system" are **essentially enumerable**: **~15–20 views** cover the core expression needs of all domains.

- View types themselves are **cross-domain universal** (a state machine is a state machine — Web, games, embedded all use them)
- **Convention** is domain-bound (how you reverse-engineer a view from code, and how you write it back to code, are completely different)
- Therefore the architecture should be **Universal View Schema + Per-Domain Adapter** (analogous to LLVM IR + Frontend/Backend)

---

## 2. Complete View Type Catalog (15 types)

### 1. **Structure View**

| Item | Content |
|---|---|
| **What it expresses** | What "things" exist in the system, and how they're organized |
| **Common forms** | Class diagrams, ER diagrams, module diagrams, ECS component diagrams, Scene Graphs |
| **Reverse from code** | Parse class/type definitions, import relationships |
| **Write back to code** | Generate class/type skeletons |

---

### 2. **Type Schema View**

| Item | Content |
|---|---|
| **What it expresses** | Data shapes + field constraints |
| **Common forms** | TypeScript types, Zod schemas, JSON Schema, Protobuf, struct definitions |
| **Reverse from code** | Parse type signatures (nearly lossless) |
| **Write back to code** | Generate types/interfaces/structs |

---

### 3. **State Machine View**

| Item | Content |
|---|---|
| **What it expresses** | Discrete states + transition conditions + events |
| **Common forms** | State diagrams, Statecharts, Animator Controllers |
| **Reverse from code** | Parse XState definitions / parse state enums and transition functions |
| **Write back to code** | Generate XState / state machine skeletons |

---

### 4. **Flow / Sequence View**

| Item | Content |
|---|---|
| **What it expresses** | Step ordering, who triggers whom, branches |
| **Common forms** | Flowcharts, sequence diagrams, Saga steps, Workflows, game tick flows |
| **Reverse from code** | Parse flow builders / function call chains |
| **Write back to code** | Generate flow skeletons |

---

### 5. **Data Flow View**

| Item | Content |
|---|---|
| **What it expresses** | Where data comes from, what it flows through, where it goes |
| **Common forms** | Pipeline diagrams, Reactive streams, signal chains, ML training pipelines |
| **Reverse from code** | Parse data transformation chains / Pipeline builders |
| **Write back to code** | Generate pipeline skeletons |

---

### 6. **Decision Table View**

| Item | Content |
|---|---|
| **What it expresses** | Business rule matrix: under what conditions, do what |
| **Common forms** | Decision tables, decision trees, rule engines, DMN standard, damage calculation tables |
| **Reverse from code** | Parse decision builders / restructure nested if-else |
| **Write back to code** | Generate decision table code |

---

### 7. **Dependency Graph View**

| Item | Content |
|---|---|
| **What it expresses** | Who depends on whom, fan-in / fan-out |
| **Common forms** | Import graphs, service dependency graphs, resource dependency graphs, Scene Graphs, Prefab references |
| **Reverse from code** | Static parse of import / require / using / #include |
| **Write back to code** | Usually read-only; modify imports as needed |

---

### 8. **Behavior Tree View**

| Item | Content |
|---|---|
| **What it expresses** | Hierarchical decision-making for complex conditional behavior |
| **Common forms** | Behavior Trees (games), Workflow decision trees, complex conditional routing |
| **Reverse from code** | Parse behavior tree DSLs / workflow definitions |
| **Write back to code** | Generate behavior tree definitions |

---

### 9. **Resource Budget View**

| Item | Content |
|---|---|
| **What it expresses** | Quantified resource consumption, limits |
| **Common forms** | Memory budgets, frame time budgets, concurrency limits, rate limiting config, GPU occupancy |
| **Reverse from code** | Parse config + static analysis + runtime profiling |
| **Write back to code** | Modify configuration files |

---

### 10. **Lifecycle View**

| Item | Content |
|---|---|
| **What it expresses** | When objects/processes/resources are created, change, and destroyed |
| **Common forms** | Process state diagrams, object lifecycles, component lifecycles, session timeout diagrams |
| **Reverse from code** | Parse constructors/destructors / lifecycle hooks |
| **Write back to code** | Generate lifecycle hook skeletons |

---

### 11. **Communication View**

| Item | Content |
|---|---|
| **What it expresses** | Who communicates with whom, using what protocol |
| **Common forms** | API call graphs, message queue topologies, event bus diagrams, network packet flows, player communication diagrams |
| **Reverse from code** | Parse RPC / API call / message publish invocations |
| **Write back to code** | Generate API clients / message-sending skeletons |

---

### 12. **Permission View**

| Item | Content |
|---|---|
| **What it expresses** | Who can do what |
| **Common forms** | RBAC matrices, ACLs, tenant isolation diagrams, game permissions, security domain boundaries |
| **Reverse from code** | Parse permission decorators / middleware / policy files |
| **Write back to code** | Generate policy code |

---

### 13. **Invariant View**

| Item | Content |
|---|---|
| **What it expresses** | Constraints that must always hold |
| **Common forms** | Constraint lists, invariant expressions, property test specifications, physical constraints, business rules |
| **Reverse from code** | Parse @invariant annotations / property test definitions |
| **Write back to code** | Generate asserts / property tests |

---

### 14. **Test Scenario View**

| Item | Content |
|---|---|
| **What it expresses** | Verification cases: given/when/then |
| **Common forms** | Unit test lists, property test descriptions, replay tests, Gherkin, game replay |
| **Reverse from code** | Parse test files |
| **Write back to code** | Generate test skeletons |

---

### 15. **Architecture View**

| Item | Content |
|---|---|
| **What it expresses** | System topology, layers, boundaries |
| **Common forms** | C4 model, hexagonal architecture diagrams, service meshes, engine subsystem diagrams, game engine layers |
| **Reverse from code** | Parse module declarations + dependency relationships + naming conventions |
| **Write back to code** | Usually read-only (architectural decisions come from above) |

---

## 3. View Usage Matrix by Domain

Each domain uses a **different subset and emphasis** of views. Stars mark importance (5-star scale).

| View Type | Web/SaaS | Backend | Mobile | Games | Embedded | ML Systems | OS/Drivers | Databases |
|---|---|---|---|---|---|---|---|---|
| Structure | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| Type/Schema | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| State Machine | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Flow/Sequence | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Data Flow | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Decision Table | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐ | ⭐⭐ |
| Dependency Graph | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Behavior Tree | ⭐ | ⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ | ⭐ | ⭐ |
| Resource/Budget | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Lifecycle | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Communication | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Permission | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Invariant | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Test Scenario | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Architecture | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

**Key observations**:
- **Type / Invariant / Resource** are important in nearly all domains
- **State Machine** is core in all "event-driven" domains
- **Decision Table / Behavior Tree** are strong in business rules and game AI, weak elsewhere
- Each domain has 8–12 "core views"; the rest are auxiliary

---

## 4. Core View Combinations by Domain (MVP priorities)

The "must-have" view combinations by domain:

### Web / SaaS (MVP priority)

| View | Used for |
|---|---|
| Type/Schema | Entity definitions, API contracts |
| State Machine | Form states, order states, UI flows |
| Flow/Sequence | API call chains, user journeys |
| Decision Table | Business rules, pricing, permission rules |
| Dependency Graph | Module dependencies, service dependencies |
| Permission | RBAC, tenant isolation |
| Invariant | Business constraints (order total = sum of items, etc.) |
| Architecture | System overview |

**8 views, covering ~90% of Web/SaaS expression needs**.

### Backend Services

| View | Used for |
|---|---|
| Type/Schema | API contracts, message formats |
| Flow/Sequence | Request processing flows, Sagas |
| Data Flow | ETL pipelines, message flows |
| Communication | Inter-service calls |
| Dependency Graph | Service dependencies |
| Invariant | Data consistency constraints |
| Permission | API permissions |
| Resource/Budget | Rate limiting, timeouts |
| Architecture | Microservice topology |

### Mobile Apps

| View | Used for |
|---|---|
| Structure | Component trees, page structures |
| State Machine | UI states, navigation states |
| Lifecycle | App / Activity / Component lifecycles |
| Type/Schema | Data models |
| Flow/Sequence | User operation flows |
| Resource/Budget | Memory, battery, network |

### Games

| View | Used for |
|---|---|
| **Structure** | ECS components, Scene hierarchy |
| **State Machine** | Character states, AI states, animation states |
| **Behavior Tree** | AI decisions, Boss behavior |
| **Dependency Graph** | Scene Graph, Prefab references, resource dependencies |
| **Resource/Budget** | Frame time, memory, GPU |
| **Lifecycle** | Object pools, player sessions |
| Decision Table | Damage calculation, loot tables, balance parameters |
| Communication | Player communication, multiplayer sync |

### Embedded / Real-time

| View | Used for |
|---|---|
| **State Machine** | Device modes, protocol states |
| **Data Flow** | Signal chains, sensor data flows |
| **Resource/Budget** | Memory, latency, interrupt response |
| **Lifecycle** | Resource RAII |
| **Invariant** | Timing constraints, safety constraints |
| Type/Schema | Struct layouts, protocol formats |
| Test Scenario | HIL tests, regression tests |

### ML Systems

| View | Used for |
|---|---|
| **Data Flow** | Training pipelines, inference pipelines |
| **Type/Schema** | Data schemas, model input/output |
| Structure | Model architecture |
| Resource/Budget | GPU, VRAM, training duration |
| Flow/Sequence | Experiment workflows |

---

## 5. When to Use Which View (by engineering task, not code lifecycle)

| Engineering Scenario | Primary views to use |
|---|---|
| **Taking over a new project, need to understand the business within a week** | Architecture → Structure → State Machine → Flow |
| **Fixing a bug, need to understand the relevant logic first** | Data Flow → State Machine → Decision Table → Invariant |
| **Adding a new feature, assessing impact scope** | Dependency Graph → Communication → Permission |
| **Optimizing performance, finding bottlenecks** | Resource/Budget → Data Flow → Communication |
| **Designing a security plan** | Permission → Communication → Invariant |
| **Refactoring, confirming behavior hasn't changed** | Test Scenario → Invariant → State Machine |
| **Reviewing someone's code, understanding PR business intent** | State Machine → Flow → Decision Table |
| **Writing a technical design doc** | Architecture → State Machine → Flow → Decision Table |
| **Explaining the business to non-technical stakeholders** | User Journey (subset of Flow) → Decision Table |
| **Responding to a production incident, debugging** | Flow → State Machine → Communication → Invariant |
| **Providing context to AI during AI-assisted coding** | Type → Invariant → Decision Table |
| **New hire onboarding** | Architecture → Structure → Main Flow |

**Insight**: **Different tasks use different view combinations**. The product UI should be organized by "task", not by "view type".

---

## 6. Precise Cross-Domain Universality Assessment

| Dimension | Universality |
|---|---|
| **View concept definition** (what is a state machine) | **100% universal** (mathematical definition is invariant) |
| **View presentation** (how to draw a state diagram) | **80% universal** (nodes + edges, largely invariant) |
| **Reverse convention** (from code to view) | **Domain-bound** (XState ≠ Unity Animator) |
| **Write-back convention** (from view to code) | **Domain-bound** |
| **View relative importance** | **Highly domain-variant** |

**Conclusion**:
- **View Schema is cross-domain shared** (can be a single standard)
- **Convention Adapters are written per domain** (LLVM model)
- **Product v1 picks one domain and does it well; long-term expansion via adapters**

---

## 7. Coverage Estimate

Based on "**can views cover a domain's core expression needs**":

| Domain | Coverage |
|---|---|
| **Web / SaaS** | **90%+** |
| **Backend Services** | **90%+** |
| **Mobile Apps** | **85%** |
| **Enterprise Systems (CRM/ERP)** | **85%+** |
| **Games** | **70%** (needs game-specific views: Shader, Material) |
| **Embedded / Real-time** | **75%** (needs timing diagrams, signal waveforms) |
| **ML Systems** | **65%** (needs experiment tracking, hyperparameters) |
| **OS / Drivers / Systems Programming** | **50%** (too low-level) |
| **Database Kernels** | **60%** |

**Conclusion**: **Covering 90% of mainstream "business software development" is feasible; covering 90% of "all software" is not**.

---

## 8. Product Architecture Implication (derived from the above view analysis)

```
┌────────────────────────────────────────────────┐
│  Universal View Schema (IR for 15 views)       │
│  Pure data, cross-domain, versioned            │
└────────────────────────────────────────────────┘
                  ↑↓
┌────────────────────────────────────────────────┐
│  Adapter Layer (one per domain)                │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐         │
│  │Web/  │ │Node  │ │Unity │ │UE    │         │
│  │React │ │Backend│ │adapt │ │adapt │         │
│  └──────┘ └──────┘ └──────┘ └──────┘         │
│  ┌──────┐ ┌──────┐ ┌──────┐                  │
│  │Embed │ │ML    │ │Mobile│                  │
│  │adapt │ │adapt │ │adapt │                  │
│  └──────┘ └──────┘ └──────┘                  │
└────────────────────────────────────────────────┘
                  ↑↓
┌────────────────────────────────────────────────┐
│  Domain Code (SSoT)                            │
└────────────────────────────────────────────────┘
```

**Analogy**: **The LLVM of software engineering** — view schema is the IR, domain adapters are frontends/backends.

---

## 9. MVP View Selection

v1 targets **Web/SaaS domain**, starting with these 5 views (highest ROI):

| Priority | View | Rationale |
|---|---|---|
| 🥇 | **Type/Schema** | Present in nearly all modern TS projects, convention is mature (Zod / TypeBox) |
| 🥈 | **State Machine** | XState has already done half the work, naturally visualizable |
| 🥉 | **Dependency Graph** | Static analysis is mature, high value |
| 4 | **Decision Table** | Standard expression for business rules |
| 5 | **Architecture** | Entry-level view, essential for onboarding |

**5 views cover 60–70% of Web/SaaS expression needs**, sufficient for MVP validation.

---

## 10. Key Strategic Insights

1. **View types are enumerable and finite** (~15 types)
2. **Cross-domain universal is the Schema; domain-bound are the Adapters** (LLVM model)
3. **Different domains use different "key view combinations"** — product UI should be organized by "task", not "view type"
4. **Covering 90% of "mainstream business software" is feasible; 90% of "all software" is not**
5. **v1 focuses on Web/SaaS; long-term expansion via adapters; the core IR stays stable**
