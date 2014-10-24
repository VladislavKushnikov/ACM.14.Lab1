package ST12;
use strict;
use Encode qw(encode decode);

my $pathfile='st12\Datafiles\654';
my @DATABASE =();
my @MODULES =(	
	\&add,
	\&edit,
	\&delete,
	\&show,
	\&save,
	\&load,
	\&exit
	);
my @ElNames=(
	'��������',
	'���⪮���',
	'�ண��',
	'��ਭ�',
	'���⥬� ���������',
	'��ଠ',
	'��थ筨�'
	);
my @NAMES =(
	'�������� ��ꥪ�',
	'������஢��� ��ꥪ�',
	'������� ��ꥪ�',
	'�뢥�� �� �࠭',
	'���࠭��� � 䠩�',
	'����㧨�� �� 䠩��',
	'��室 �� �ணࠬ��'
	);
		
sub menu{
	my $i = 0;
	print "\n------------------------------\n";
	foreach my $s(@NAMES){
		$i++;
		print "$i. $s\n";
	}
	print "------------------------------\n";
	my $ch = <STDIN>;
	return ($ch-1);
}
sub st12{
	while(1){
		my $ch = menu();
		if($ch>=0&&defined $MODULES[$ch]){
			$MODULES[$ch]->();
		}
		else{
			system("cls");
			print "�����⥫쭥�!";
			next;
		}
	}
}

sub add{
	system("cls");
	my $ref2hash = {};
	my $i = 0;
	foreach my $e(@ElNames){
		$i++;
		print "$i.$e: ";
		chomp(my $str = <STDIN>);
		$ref2hash->{$e} = $str;
	}
	@DATABASE=(@DATABASE,$ref2hash);
}

sub show{
	system("cls");
	if (!defined $DATABASE[0]) {	
		print "���� ����\n";
		return;
	};
	my $i = 0;
	#print "�������� ��� ��ꥪ⮢:\n";
	foreach my $ref2hash(@DATABASE){
		$i++;
		#print "$i.$ref2hash->{$ElNames[0]}\n";
		print "\n$i.$ElNames[0]: $ref2hash->{$ElNames[0]}";
		foreach my $o(@ElNames)		{
		 	if ($o eq $ElNames[0]) {next;}
		 	print "\n\t$o: $ref2hash->{$o}";
		}
	}
}

sub edit{
	system("cls");
	if (!defined $DATABASE[0]) {	
		print "������஢��� ��祣�\n";
		return;
	};
	while(1){
		print '����� ।����㥬��� ��ꥪ�: ';
		my $n = <STDIN>-1;
		if ($n<0||!defined $DATABASE[$n]){
			system("cls");
			print "��ꥪ� � ⠪�� ����஬ �� �������\n";
			next;
		}
		my $ref2hash = $DATABASE[$n];
		$n = 0;
		foreach my $e(@ElNames){
			$n++;
			print "\n$n.$e: $ref2hash->{$e}";
		}
		print "\n\n����� ।���६��� ��ࠬ���: ";
		$n = <STDIN>-1;
		if ($n<0||!defined $ElNames[$n]){
			system("cls");
			print "��ࠬ��� � ⠪�� ����஬ �� �������\n";
			next;
		}
		print "\n������ ���������\n$ElNames[$n]: ";
		chomp(my $m = <STDIN>);
		$ref2hash->{$ElNames[$n]} = $m;
		last;
	}
}

sub delete{
	system("cls");
	if (!defined $DATABASE[0]) {	
		print "������� ��祣�\n";
		return;
		};
	while(1){
		print "����� 㤠�塞��� ��ꥪ�: ";
		my $n = <STDIN>-1;
		if ($n<0||!defined $DATABASE[$n]){
			system("cls");
			print "��ꥪ� � ⠪�� ����஬ �� �������\n";
			next;
		}
		splice(@DATABASE, $n, 1);
		last;
	}
}

sub save{#��祣� ���� � ������ �� ��諮 ��� ��࠭����/����㧪�
	system("cls");
	print "����(0 ��� �ᯮ�짮����� ��.�.): ";
	chomp(my $str = <STDIN>);
	if(!$str){$str=$pathfile};
	my %g;
	if(!dbmopen(%g, $str, 0644)){
		print "$!";
		return;
	}
	%g = ();
	my $i = 0;
	foreach my $ref2hash(@DATABASE){
		foreach my $o(@ElNames){
			$g{$i} .= Encode::encode('windows-1251', Encode::decode('cp866', "$o<==>$ref2hash->{$o}<===>"));
		}
		$i++;
	}
	dbmclose(%g);
}

sub load{
	system("cls");
	print "����(0 ��� �ᯮ�짮����� ��.�.): ";
	chomp(my $name = <STDIN>);
	if(!$name){$name=$pathfile};
	my %g;
	if(!dbmopen(%g, $name, 0)){
		print "\n�� ���� ������ $name!";
		return;
	}
	@DATABASE=();
	foreach my $value(values %g){
		$value = Encode::encode('cp866', Encode::decode('windows-1251', $value));
		my $ref2hash = {};
		my @array = split(/<===>/, $value);
		foreach my $ar(@array){
			my ($key, $val) = split(/<==>/, $ar);
			$ref2hash->{$key}=$val;
		}
		@DATABASE=(@DATABASE,$ref2hash);
	}
	dbmclose(%g);
}