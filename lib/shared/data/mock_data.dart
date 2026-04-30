class MockData {
  static const tasks = [
    {
      'id': 't-1',
      'title': 'Finalize API Documentation',
      'source': 'PMS',
      'context': 'Project: Notify Africa',
      'status': 'In-Progress',
      'priority': 'High',
      'due': 'Yesterday',
      'points': '4',
      'description':
          'Complete the Swagger documentation for the new notification endpoints.',
      'assignee': 'Erick',
      'overdue': 'true',
    },
    {
      'id': 't-2',
      'title': 'Fix Login Page CSS Bug',
      'source': 'Ticketing',
      'context': 'Ticket: IT Ops',
      'status': 'Pending',
      'priority': 'Medium',
      'due': 'Today',
      'points': '2',
      'description': 'The login button is misaligned on mobile Safari.',
      'assignee': 'John',
      'overdue': 'false',
    },
    {
      'id': 't-3',
      'title': 'Review Q3 Resource Allocation',
      'source': 'PMS',
      'context': 'Project: Internal PMO',
      'status': 'Review',
      'priority': 'Critical',
      'due': 'Today',
      'points': '3',
      'description':
          'Review and approve the resource allocation matrix for Q3 projects.',
      'assignee': 'Erick',
      'overdue': 'false',
    },
    {
      'id': 't-4',
      'title': 'Update Employee Onboarding Guide',
      'source': 'Ticketing',
      'context': 'Ticket: HR',
      'status': 'Blocked',
      'priority': 'Low',
      'due': 'In 2 days',
      'points': '3',
      'description':
          'Need the new IT policies from the security team before finalizing.',
      'assignee': 'Sarah',
      'overdue': 'false',
    },
    {
      'id': 't-5',
      'title': 'Database Migration Script',
      'source': 'PMS',
      'context': 'Project: Core Platform',
      'status': 'Completed',
      'priority': 'High',
      'due': '3 days ago',
      'points': '8',
      'description': 'Write and test the V4 to V5 database migration script.',
      'assignee': 'Erick',
      'overdue': 'false',
    },
  ];

  static const notifications = [
    {
      'type': 'Mention',
      'message': '@Erick, can you check the latest design files?',
      'time': '1h ago',
      'isRead': 'false',
    },
    {
      'type': 'Deadline',
      'message': 'Task "Finalize API Documentation" is overdue!',
      'time': '2h ago',
      'isRead': 'false',
    },
    {
      'type': 'Review',
      'message': 'Sarah requested a review on Q3 Resource Allocation.',
      'time': '1d ago',
      'isRead': 'true',
    },
  ];

  static const projects = [
    {
      'name': 'Notify Africa Integration',
      'description':
          'Integration of the Notify Africa API into the core banking system.',
      'client': 'Ministry of Finance',
      'pm': 'Erick',
      'timeline': 'Jan 15 - Jun 30, 2026',
      'priority': 'High',
      'status': 'Active',
      'progress': '0.72',
      'milestones': '3',
      'tasks': '5',
      'documents': '2',
    },
    {
      'name': 'Health Portal Revamp',
      'description': 'Redesign and development of the patient portal.',
      'client': 'Global Health NGO',
      'pm': 'Sarah Jenkins',
      'timeline': 'Mar 1 - Sep 30, 2026',
      'priority': 'Medium',
      'status': 'Active',
      'progress': '0.30',
      'milestones': '1',
      'tasks': '0',
      'documents': '0',
    },
  ];

  static const clients = [
    {
      'name': 'Acme Corp',
      'type': 'Company',
      'industry': 'Technology',
      'region': 'North America',
    },
    {
      'name': 'Global Health NGO',
      'type': 'NGO',
      'industry': 'Healthcare',
      'region': 'Europe',
    },
    {
      'name': 'Ministry of Finance',
      'type': 'Government',
      'industry': 'Finance',
      'region': 'Africa',
    },
  ];

  static const targets = [
    {
      'title': 'Q3 Revenue Goal',
      'status': 'On Track',
      'progress': '0.70',
      'value': r'$350k of $500k',
    },
    {
      'title': 'Client Satisfaction Score',
      'status': 'Achieved',
      'progress': '1.0',
      'value': '4.8 of 4.5 pts',
    },
    {
      'title': 'Project Delivery Time',
      'status': 'Behind',
      'progress': '0.33',
      'value': '5% of 15%',
    },
    {
      'title': 'Resource Utilization',
      'status': 'At Risk',
      'progress': '0.92',
      'value': '92% of 80%',
    },
  ];

  static const resources = [
    {
      'name': 'Erick',
      'role': 'Project Manager',
      'project': 'Notify Africa',
      'load': '0.50',
    },
    {
      'name': 'Sarah Jenkins',
      'role': 'Assistant PM',
      'project': 'Notify Africa',
      'load': '0.30',
    },
    {
      'name': 'Michael Chen',
      'role': 'Backend Developer',
      'project': 'Notify Africa',
      'load': '1.00',
    },
    {
      'name': 'Aisha Patel',
      'role': 'QA Engineer',
      'project': 'Health Portal',
      'load': '0.80',
    },
  ];

  static const workPlans = [
    {
      'title': 'Requirements Gathering',
      'date': 'Feb 1, 2026',
      'status': 'Completed',
    },
    {
      'title': 'API Integration Phase 1',
      'date': 'Mar 15, 2026',
      'status': 'Completed',
    },
    {'title': 'UAT Sign-off', 'date': 'May 1, 2026', 'status': 'Pending'},
    {
      'title': 'Production Deployment',
      'date': 'Jun 30, 2026',
      'status': 'Draft',
    },
  ];

  static const tickets = [
    {
      'id': 't-1',
      'title': 'Cannot access the PMO Dashboard',
      'description':
          'When I try to log into the PMO dashboard, I get a 403 Forbidden error. I was able to access it yesterday.',
      'priority': 'High',
      'status': 'Open',
      'category': 'Bug',
      'reporter': 'Sarah Jenkins',
      'assignee': '',
    },
    {
      'id': 't-2',
      'title': 'Need a new laptop for the new hire',
      'description':
          'We have a new developer starting next Monday. Need a MacBook Pro M3 provisioned.',
      'priority': 'Medium',
      'status': 'In Progress',
      'category': 'IT',
      'reporter': 'Erick',
      'assignee': 'IT Support',
    },
    {
      'id': 't-2',
      'title': 'Need a new laptop for the new hire',
      'description':
          'We have a new developer starting next Monday. Need a MacBook Pro M3 provisioned.',
      'priority': 'Medium',
      'status': 'In Progress',
      'category': 'IT',
      'reporter': 'Erick',
      'assignee': 'IT Support',
    },
    {
      'id': 't-3',
      'title': 'Add dark mode to the Meals app',
      'description':
          'It would be great to have a dark mode option for the Meals app, especially for late-night planning.',
      'priority': 'Low',
      'status': 'Resolved',
      'category': 'Feature',
      'reporter': 'Alex Smith',
      'assignee': 'Erick',
    },
  ];

  static const users = [
    {
      'firstName': 'Erick',
      'lastName': 'M',
      'email': 'erick@ipfsoftwares.com',
      'department': 'Engineering',
      'jobTitle': 'Lead Developer',
      'status': 'Active',
    },
    {
      'firstName': 'Sarah',
      'lastName': 'Connor',
      'email': 'sarah@ipfsoftwares.com',
      'department': 'Operations',
      'jobTitle': 'Project Manager',
      'status': 'Active',
    },
    {
      'firstName': 'Michael',
      'lastName': 'Scott',
      'email': 'michael@ipfsoftwares.com',
      'department': 'Management',
      'jobTitle': 'Regional Manager',
      'status': 'On-Leave',
    },
  ];

  static const roles = [
    {
      'name': 'Super Admin',
      'description': 'Full access to all modules and settings.',
      'type': 'Global',
      'permissions': 'users: Full,pms: Full,ticketing: Full,meals: Full',
    },
    {
      'name': 'Employee',
      'description': 'Standard employee access.',
      'type': 'Global',
      'permissions': 'users: View,pms: View,ticketing: Edit,meals: Edit',
    },
    {
      'name': 'Developer',
      'description': 'PMS Developer access.',
      'type': 'App-Specific',
      'permissions': 'pms.code: Full,pms.tasks: Edit',
    },
    {
      'name': 'Project Manager',
      'description': 'PMS Manager access.',
      'type': 'App-Specific',
      'permissions': 'pms.projects: Full,pms.tasks: Full,pms.resources: Edit',
    },
  ];

  static const auditLogs = [
    {
      'action': 'Updated Profile',
      'module': 'Users',
      'details': 'Changed dietary preferences.',
      'time': 'Now',
    },
    {
      'action': 'Created Project',
      'module': 'PMS',
      'details': 'Created Skynet MVP.',
      'time': '1h',
    },
    {
      'action': 'Assigned Role',
      'module': 'Users',
      'details': 'Assigned Developer to u1.',
      'time': '2h',
    },
  ];

  static const mains = [
    {'id': 'm1', 'name': 'Wali (Rice)', 'popularity': 145},
    {'id': 'm2', 'name': 'Ugali', 'popularity': 120},
    {'id': 'm3', 'name': 'Chips (Fries)', 'popularity': 190},
    {'id': 'm4', 'name': 'Ndizi (Bananas)', 'popularity': 85},
    {'id': 'm5', 'name': 'Pilau', 'popularity': 210},
    {'id': 'm6', 'name': 'Chapati', 'popularity': 175},
  ];

  static const sides = [
    {'id': 's1', 'name': 'Kuku (Chicken)', 'popularity': 200},
    {'id': 's2', 'name': 'Nyama (Beef)', 'popularity': 180},
    {'id': 's3', 'name': 'Samaki (Fish)', 'popularity': 150},
    {'id': 's4', 'name': 'Maharage (Beans)', 'popularity': 110},
    {'id': 's5', 'name': 'Mboga (Greens)', 'popularity': 130},
  ];

  static const holidays = [
    {'id': 'h-ny26', 'date': '2026-01-01', 'name': 'New Year\'s Day'},
    {'id': 'h-zr26', 'date': '2026-01-12', 'name': 'Zanzibar Revolution Day'},
    {'id': 'h-eidfitr26', 'date': '2026-03-20', 'name': 'Eid al-Fitr (Approx)'},
    {'id': 'h-gf26', 'date': '2026-04-03', 'name': 'Good Friday'},
    {'id': 'h-em26', 'date': '2026-04-06', 'name': 'Easter Monday'},
    {'id': 'h-kar26', 'date': '2026-04-07', 'name': 'Karume Day'},
    {'id': 'h-un26', 'date': '2026-04-26', 'name': 'Union Day'},
    {'id': 'h-lab26', 'date': '2026-05-01', 'name': 'Labour Day'},
    {'id': 'h-eidadha26', 'date': '2026-05-27', 'name': 'Eid al-Adha (Approx)'},
    {'id': 'h-saba26', 'date': '2026-07-07', 'name': 'Saba Saba'},
    {'id': 'h-nane26', 'date': '2026-08-08', 'name': 'Nane Nane'},
    {'id': 'h-maulid26', 'date': '2026-08-27', 'name': 'Maulid Day (Approx)'},
    {'id': 'h-nyerere26', 'date': '2026-10-14', 'name': 'Nyerere Day'},
    {'id': 'h-rep26', 'date': '2026-12-09', 'name': 'Republic Day'},
    {'id': 'h-xmas26', 'date': '2026-12-25', 'name': 'Christmas Day'},
    {'id': 'h-box26', 'date': '2026-12-26', 'name': 'Boxing Day'},
  ];

  static const historicalPlans = [
    {
      'id': 'wp-last-week',
      'weekStartDate': '2026-04-20',
      'status': 'Archived',
      'selections': [
        {'day': 'Monday', 'mainId': 'm1', 'sideId': 's1', 'status': 'Consumed'},
        {'day': 'Tuesday', 'mainId': 'm2', 'sideId': 's2', 'status': 'Consumed'},
        {'day': 'Wednesday', 'mainId': 'm5', 'sideId': 's1', 'status': 'Consumed'},
        {'day': 'Thursday', 'mainId': 'm3', 'sideId': 's3', 'status': 'Consumed'},
        {'day': 'Friday', 'mainId': 'm6', 'sideId': 's4', 'status': 'Consumed'},
      ]
    }
  ];

  static const currentPlan = {
    'id': 'wp-this-week',
    'weekStartDate': '2026-04-27',
    'status': 'Submitted',
    'selections': [
      {'day': 'Monday', 'mainId': 'm5', 'sideId': 's2', 'status': 'Consumed'},
      {'day': 'Tuesday', 'mainId': 'm1', 'sideId': 's4', 'status': 'Pending'},
      {'day': 'Wednesday', 'mainId': 'm3', 'sideId': 's1', 'status': 'Pending'},
      {'day': 'Thursday', 'mainId': 'm2', 'sideId': 's5', 'status': 'Pending'},
      {'day': 'Friday', 'mainId': 'm6', 'sideId': 's1', 'status': 'Pending'},
    ]
  };

  static const nextWeekPlan = {
    'id': 'wp-next-week',
    'weekStartDate': '2026-05-04',
    'status': 'Draft',
    'selections': [
      {'day': 'Monday', 'mainId': 'm3', 'sideId': 's1', 'status': 'Pending'},
      {'day': 'Tuesday', 'mainId': 'm1', 'sideId': 's2', 'status': 'Pending'},
      {'day': 'Wednesday', 'mainId': 'm5', 'sideId': 's3', 'status': 'Pending'},
      {'day': 'Thursday', 'mainId': 'm6', 'sideId': 's1', 'status': 'Pending'},
      {'day': 'Friday', 'mainId': null, 'sideId': null, 'status': 'Pending'},
    ]
  };

  static const teamMeals = [
    {
      'name': 'Erick',
      'day': 'Monday',
      'mainId': 'm5',
      'sideId': 's2',
      'status': 'Submitted',
    },
    {
      'name': 'Sarah Jenkins',
      'day': 'Tuesday',
      'mainId': 'm1',
      'sideId': 's4',
      'status': 'Submitted',
    },
    {
      'name': 'Michael Chen',
      'day': 'Wednesday',
      'mainId': 'm3',
      'sideId': 's1',
      'status': 'Draft',
    },
    {
      'name': 'Aisha Patel',
      'day': 'Friday',
      'mainId': 'm6',
      'sideId': 's3',
      'status': 'Submitted',
    },
  ];
}
