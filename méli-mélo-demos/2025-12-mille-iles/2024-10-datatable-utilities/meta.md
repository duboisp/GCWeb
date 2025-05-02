---
feature: méli-mélo
'@context':
  '@version': 1.0.4
  dct: http://purl.org/dc/terms/
  title:
    '@id': dct:title
    '@container': '@language'
  description: dct:description
  modified: dct:modified
title:
  en: Data Table Utilities
  fr: (FR) Data Table Utilities
description: Examples of how to use these Utilities
modified: 2024-11-12T00:00:00.000Z
componentName: 2024-10-datatable-utilities
sponsor: Steve Bourgeois (steve.bourgeois@tpsgc-pwgsc.gc.ca)
pages:
  examples:
    - title: DataTable Utilities
      language: en
      path: index-en.html
    - title: Utilitaire DataTable
      language: fr
      path: index-fr.html
  documentation:
    - title: DataTable Utilities - Documentation
      language: en
      path: datatable-utilities-doc-en.html
    - title: Utilitaire DataTable - Documentation
      language: fr
      path: datatable-utilities-doc-fr.html
implementationPlan:
  - due: 2024-09-24T00:00:00.000Z
    what: Initial Development <span class="label label-success">Completed</span>
  - due: 2024-10-01T00:00:00.000Z
    what: >-
      Get Initial Feedback from Wet-Boew Team Before Pull Request <span
      class="label label-success">Completed</span>
  - due: 2024-10-08T00:00:00.000Z
    what: >-
      Fix Issue Identified by Wet-Boew Team <span class="label
      label-success">Completed</span>
  - due: 2024-10-12T00:00:00.000Z
    what: >-
      Get French Sample page Translated <span class="label
      label-success">Completed</span>
  - due: 2024-10-15T00:00:00.000Z
    what: >-
      Get Pages through our QC cycle and our WACR Team <span class="label
      label-success">Completed</span>
  - due: 2024-10-22T00:00:00.000Z
    what: >-
      Fix Identified problems and accessibility issues <span class="label
      label-success">Completed</span>
  - due: 2024-10-24T00:00:00.000Z
    what: Submit Pull Request <span class="label label-success">Completed</span>
  - due: 2025-11-30T00:00:00.000Z
    what: >-
      Produce accessibility conformance report <span class="label
      label-warning">Todo</span>
  - due: 2025-06-30T00:00:00.000Z
    what: >-
      Work toward a provisional plugin <span class="label label-warning">In
      Progress</span>
implementationPlanFR:
  - due: 2024-09-24T00:00:00.000Z
    what: Développement initial <span class="label label-success">Complété</span>
  - due: 2024-10-01T00:00:00.000Z
    what: >-
      Obtenir des rétroaction de l'équipe Wet-Boew avant la demande de tirage
      <span class="label label-success">Complété</span>
  - due: 2024-10-08T00:00:00.000Z
    what: >-
      Corriger tout problèmes identifiés par l'équipe Wet-Boew <span
      class="label label-success">Complété</span>
  - due: 2024-10-12T00:00:00.000Z
    what: >-
      Faire traduire la page d'exemple en français <span class="label
      label-success">Complété</span>
  - due: 2024-10-15T00:00:00.000Z
    what: >-
      Soumettre les pages à notre processus de CQ et à notre équipe ECAW <span
      class="label label-success">Complété</span>
  - due: 2024-10-22T00:00:00.000Z
    what: >-
      Corriger les problèmes identifiés et les problèmes d'accessibilité <span
      class="label label-success">Complété</span>
  - due: 2024-10-24T00:00:00.000Z
    what: >-
      Soumettre la demandes de tirage <span class="label
      label-success">Complété</span>
  - due: 2025-11-30T00:00:00.000Z
    what: >-
      Produce accessibility conformance report <span class="label
      label-warning">A faire</span>
  - due: 2025-06-30T00:00:00.000Z
    what: >-
      Travailler vers un plugiciel provisoire <span class="label
      label-success">En cours</span>
todos:
  - Add Other Data Manipulation Classes Maybe (percentage)?
todosFR:
  - >-
    Envisager d'ajouter d'autres classes de manipulation de données
    (pourcentage)?
changes:
  - date: 2025-01-23T00:00:00.000Z
    description: >-
      Change was to fix a bug with tables that have hidden columns. The hidden
      columns caused the formatting to apply to the wrong column.
    departmentImpact: >-
      The bug is now fixed and the workaround of having to move the hidden
      columns to the end is no longer necessary.
    publicImpact: >-
      The bug is now fixed and the workaround of having to move the hidden
      columns to the end is no longer necessary.
  - date: 2024-11-01T00:00:00.000Z
    description: >-
      DataTable Utilities, includes Data Manipulation Classes for emails, Urls
      and Money. Also Includes Datatable Footer Totals
    departmentImpact: >-
      Having this plugin integrated will make the transition to Canada.ca easier
      as these features are already in use on https://www.tpsgc-pwgsc.gc.ca,
      currently some of the pages that make use of this plugin and other pages
      that make use of Other JavaScripts are just pointed to from Canada.ca
    publicImpact: >-
      The Public at Large, the plugin makes DataTables more user friendly with
      Clickable Links, and they are used to this functionality our PRE Canada.ca
      Pages
output: false
script: ../../../dist/GCWeb/méli-mélo/2025-12-mille-iles.js
css: ../../../dist/GCWeb/méli-mélo/2025-12-mille-iles.css
---
