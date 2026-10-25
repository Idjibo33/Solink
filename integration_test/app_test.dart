import 'package:integration_test/integration_test.dart';

import '../test/helpers/auth_flow_scenarios.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  defineAuthFlowScenarios();
}
