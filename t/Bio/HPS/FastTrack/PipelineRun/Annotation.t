#!/usr/bin/env perl
use Moose;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
BEGIN {
    use Test::Most;
    use_ok('Bio::HPS::FastTrack::PipelineRun::Annotation');
  }

ok( my $annotation_runner = Bio::HPS::FastTrack::PipelineRun::Annotation->new( study =>  2027, database => 'pathogen_prok_track_test', mode => 'prod' ), 'Creating a Annotation runner object');
isa_ok ( $annotation_runner, 'Bio::HPS::FastTrack::PipelineRun::Annotation' );
ok ( my $study = $annotation_runner->study_metadata(), 'Creating study object');
isa_ok ( $study, 'Bio::HPS::FastTrack::VRTrackWrapper::Study');
ok ( $study->lanes(), 'Collecting lanes');

$annotation_runner->run();

isa_ok ($study->lanes()->{'7138_6#17'}, 'VRTrack::Lane');
is( $annotation_runner->study_metadata->vrtrack_study->hierarchy_name(), 'Comparative_RNA_seq_analysis_of_three_bacterial_species', 'Study name');
is( $study->lanes()->{'7138_6#17'}->processed(), 15, 'Processed flag');
is( $study->lanes()->{'7138_6#17'}->hierarchy_name(), '7138_6#17', 'Lane name');

is( $study->lanes()->{'7153_1#20'}->processed(), 1035, 'Processed flag annotated2');
is( $study->lanes()->{'7153_1#20'}->hierarchy_name(), '7153_1#20', 'Lane name annotated2');


ok ( my $config = $annotation_runner->config_data(), 'Creating config object');
is ( $config->config_root(), '/nfs/pathnfs05/conf', 'Root path of config files');
ok ( $config->config_root('t/data/conf'), 'Creating config object');
is ( $config->config_root(), 't/data/conf', 'Root path of config files');
is ( $config->path_to_high_level_config(), 't/data/conf/pathogen_prok_track_test/pathogen_prok_track_test_annotate_assembly_pipeline.conf', 'Annotation test configuration directory');
is ( $config->path_to_low_level_config(),
     't/data/conf/pathogen_prok_track_test/annotation/annotate_assembly_Comparative_RNA_seq_analysis_of_three_bacterial_species_Streptococcus_pyogenes_Streptococcus_pyogenes_BC2_HKU16_v0.1_bwa.conf',
     'Low level config'
   );

done_testing();
