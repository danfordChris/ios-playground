import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';

void main() {
  final generators = <BaseModelGenerator>[
    // Other Models
  ];
  CodeGenerator.of("ai_playground", generators).generate();
}
