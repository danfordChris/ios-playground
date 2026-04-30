# Source Web App Map

Source root:

```text
/Users/danfordchris/projects/ipf_apps/OS/remix_-ipf-os---ux-design
```

## Entry Points

- `src/main.tsx`
- `src/App.tsx`
- `src/index.css`
- `src/lib/store.ts`
- `src/lib/utils.ts`

## Route Gate

`src/App.tsx` checks `currentUser` from `useAppStore`. If missing, it renders
`Login`. Once logged in, routes are:

- `/` -> `Launcher`
- `/meals/*` -> `IPFMealsApp`
- `/projects/*` -> `ProjectManagementApp`
- `/tasks/*` -> `MyTasksApp`
- `/users/*` -> `UserManagementApp`
- `/ticketing/*` -> `TicketingApp`

## Shared Components

- `src/components/ui/AppLayout.tsx`
- `src/components/ui/DocumentUploader.tsx`
- `src/components/ui/ErrorBoundary.tsx`
- `src/components/ui/Input.tsx`
- `src/components/ui/Modal.tsx`
- `src/components/ui/Select.tsx`
- `src/components/ui/SlideOver.tsx`
- `src/components/ui/Textarea.tsx`

## Feature Components

### Auth

- `src/features/auth/components/Login.tsx`

### Launcher

- `src/features/launcher/components/Launcher.tsx`

### IPF Meals

- `src/features/ipf-meals/components/EmployeeSelections.tsx`
- `src/features/ipf-meals/components/Home.tsx`
- `src/features/ipf-meals/components/IPFMealsApp.tsx`
- `src/features/ipf-meals/components/MealConfiguration.tsx`
- `src/features/ipf-meals/components/MealLibrary.tsx`
- `src/features/ipf-meals/components/MyPlan.tsx`
- `src/features/ipf-meals/components/MySelections.tsx`
- `src/features/ipf-meals/components/Planner.tsx`
- `src/features/ipf-meals/services/mockData.ts`
- `src/features/ipf-meals/types/index.ts`

### Project Management

- `src/features/project-management/components/CapacityChart.tsx`
- `src/features/project-management/components/Dashboard.tsx`
- `src/features/project-management/components/ProjectList.tsx`
- `src/features/project-management/components/ProjectManagementApp.tsx`
- `src/features/project-management/hooks/useProjectForm.ts`
- `src/features/project-management/services/dashboardData.ts`
- `src/features/project-management/services/mockData.ts`
- `src/features/project-management/types/index.ts`

### My Tasks

- `src/features/my-tasks/components/BlockerModal.tsx`
- `src/features/my-tasks/components/CapacityVisualizer.tsx`
- `src/features/my-tasks/components/Dashboard.tsx`
- `src/features/my-tasks/components/FocusMode.tsx`
- `src/features/my-tasks/components/KanbanBoard.tsx`
- `src/features/my-tasks/components/KanbanColumn.tsx`
- `src/features/my-tasks/components/MyTasksApp.tsx`
- `src/features/my-tasks/components/NotificationCenter.tsx`
- `src/features/my-tasks/components/TaskCard.tsx`
- `src/features/my-tasks/components/TaskDetailPanel.tsx`
- `src/features/my-tasks/components/TaskItem.tsx`
- `src/features/my-tasks/services/mockData.ts`
- `src/features/my-tasks/types/index.ts`

### User Management

- `src/features/user-management/components/AuditLogs.tsx`
- `src/features/user-management/components/Directory.tsx`
- `src/features/user-management/components/OffboardingModal.tsx`
- `src/features/user-management/components/RolesMatrix.tsx`
- `src/features/user-management/components/UserManagementApp.tsx`
- `src/features/user-management/components/UserProfile.tsx`
- `src/features/user-management/services/mockData.ts`
- `src/features/user-management/types/index.ts`

### Ticketing

- `src/features/ticketing/components/TicketDetails.tsx`
- `src/features/ticketing/components/TicketingApp.tsx`
- `src/features/ticketing/components/TicketList.tsx`
- `src/features/ticketing/services/mockData.ts`
- `src/features/ticketing/types/index.ts`

## Source Dependencies To Consider In Flutter Equivalents

- `react-router` -> Flutter navigation/router.
- `zustand` -> providers or local app state.
- `lucide-react` -> Flutter material/cupertino icons or an icon package if
  already available.
- `recharts` -> Flutter chart widgets or custom lightweight chart painters.
- `dnd-kit` -> Flutter drag/drop only where required by mobile behavior.
- `xlsx` and document upload flows -> recreate only if exposed in mobile UI.

