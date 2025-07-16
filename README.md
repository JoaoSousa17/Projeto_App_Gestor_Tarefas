# Task Manager App – AI-Driven Proof of Concept

## 1. Context
This repository documents a personal experiment conducted in mid-2024.  
With **zero prior experience in Dart or Flutter**, I set out to build a fully working task-management mobile app **exclusively by leveraging generative AI**—namely OpenAI ChatGPT and Anthropic Claude—for every line of code, architecture decision, and bug fix. My objective was to measure how far current AI tooling can take a developer from _blank screen_ to _shipping app_ without direct manual coding.

---

## 2. Technologies Used
| Category | Stack / Service | Role in the Project |
|----------|-----------------|---------------------|
| **Programming languages** | **Dart** (Flutter), **Python** | Dart/Flutter powers the cross-platform UI; Python was mainly used for data anlysis graphs. |
| **Frameworks & SDKs** | **Flutter 3.22** | Cross-platform mobile UI toolkit targeting Android & iOS. |
| **Generative AI** | **OpenAI ChatGPT (o3, GPT-4-Turbo)** & **Anthropic Claude 3** | Generated all source files, refactors, and troubleshooting steps through structured prompts. |
| **Dev Tooling** | Git & GitHub | Version control and issue tracking. |

---

## 3. Methodology
1. **Segmented Development**  
   * Each screen (Home, Task Details, Settings, …) was broken down into micro-features (UI layout, state management, data validation, etc.).
2. **Sequential Implementation**  
   * Features were generated and integrated one at a time, reducing context length and easing debugging.
3. **Explicit, Layered Prompts**  
   * Prompts followed a strict template: _“Goal → Constraints → Current code → Desired output”_.  
   * Both AI systems were asked to explain design choices, fostering easier error tracing.
4. **Human Overwatch Only**  
   * I refrained from writing code directly; intervention was restricted to:  
     * clarifying prompts,  
     * merging AI patches,  
     * running the app and reporting stack traces back to the models.

---

## 4. Results of the Experiment
* **Strong suits**  
  * Rapid scaffolding of boilerplate (navigation, theming, basic CRUD) with near-perfect syntax.  
  * Consistent adherence to Flutter best practices when explicitly requested (e.g., `ValueNotifier`, `ChangeNotifierProvider`, `FutureBuilder` patterns).
* **Limitations observed**  
  * Innovative features—or any integration that crossed package boundaries (e.g., local notifications + SQLite + animations)—triggered numerous small but blocking errors (null-safety mismatches, async leaks, outdated API calls).  
  * Both models occasionally hallucinated non-existent Flutter APIs or package versions, requiring manual correction.
* **Bottom line**  
  * AI cut initial development time dramatically and acted as an efficient pair-programmer.  
  * **However, neither system could deliver an end-to-end, production-ready build without targeted human intervention.**  
  * The experiment reaffirms AI’s role as a powerful accelerator—not a full replacement—for software engineers… at least for now.
