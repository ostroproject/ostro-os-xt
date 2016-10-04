# With lack of task dependency between 'do_removebinaries' and 'do_removecruft'
# seen some timing issues on parallel builds, 'find' in do_removebinaries try
# to work on directories already removed by do_removecruft.,
# Hence we make sure that both tasks execute sequentially than parallelly.
#
# Patch status: submitted[http://lists.openembedded.org/pipermail/openembedded-devel/2016-October/109464.html]
#
# Remove existing do_removecruft
deltask removecruft
# Add do_removecruft after do_removebinaries
addtask removecruft before do_patch after do_removebinaries
