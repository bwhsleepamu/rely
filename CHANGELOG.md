## 0.7.2

### Bug Fix
- Fixed asset download problems related to the location of the temporary zipfile directory.
- Fixed timezone bug. Default time zone set to Eastern Time, and time display now includes the timezone.

## 0.7.1

### Bug Fix
- Fixed Chosen select field bug on original results page.
- Fixed bug that prevented original results from showing up in zipped download of exercise.
- Permanently fixed handing of asset urls with sub-uris, using jbuilder.
- Fixed travis-ci errors.
- Fixed errors in showing completion percentage to scorers.
- Fixed significant digit problem for completion percentages.
- Ensured zipped file downloads actually include the files, not just the file names.
- Fixed chosen dropdown cutoff problem. 

## 0.7.0

### Enhancements
- Converted Changelog and Readme to Markdown.
- Shows `ajax loader` when files are being added to upload queue.
- Study, Group, Study Type, and Rule pages are searchable and sortable by Project.
- Email switched to NTLM.
- Notification popup moved to center of screen.
- Folder structure for bulk exercise downloads updated.


### Bug Fix
- Scorer Results page validation fail does not clear uploaded files or assessment questionaire form.
- Uploader functionality for Scorer Result updated with many fixes.

## 0.6.1 (February 12, 2013)

### Enhancements
- File list made available for Original Results.

### Bug Fix
- Moved `jquery-fileupload-rails` gem outside of assets group in Gemfile.
- Scoped uniqueness validation by project for models that are scoped by project.
- Fixed `Add New Original Result` button functionality for new studies.
- Removed extra text in assessment questionaire.
- Fixed Original Results file uploader modal buttons.
- Fixed original result file upload for new studies.
- Added missing attachment download links in exercise management.


## 0.6.0 (February 5, 2013)

### Enhancements
- Added release dates to Changelog.
- Added bulk upload functionality to results and original results using jQuery Uploader plugin.
- Added asset download and bulk (zipped file) asset download functionality for exercises, results, and studies.
- Added search, pagination, and order capabilities to index page of Study Types, Studies, Groups, Rules, and Projects.
- Ensured ajax loader gif plays while index list is getting updated with search, pagination, or order.
- Added completion status to scorer pages.

### Bug Fix
- Removed "Deleted" column from all index displays
- Fixed runaway precision on exercise show page.
- Removed link from pending scorers list.
- Fixed Chosen styling.
- Fixed create/update submit button wording inconsistencies.
- Fixed default project bug and implemented handling of the creation of project-dependent objects when no project is yet selected.

## 0.5.1 (January 8, 2013)

### Enhancements
- Updated to Contour 1.1.2 and use Contour pagination theme.
- User settings page added for information about changing Gravatar.
- Added About page to provide a little more information about Rely.

### Refactoring
- Replaced deprecated `<center>` tag with CSS center class.

### Bug Fix
- Fixed projects owned by a user not showing up as managable.

### Security Fix
- Updated Rails to 3.2.11


## 0.5.0 (December 4, 2012)

### Enhancements
- All models are somehow associated with a User, using `creator_id` if necessary.
- Implemented scoping by project across the entire site.

## 0.4.0 (October 23, 2012)

### Enhancements
- Implemented original result functionality.
- Added original results for comparison with rescored result in admin exercise result table.

### Refactoring
- Refactored Model Structure for Original Result support.
- Added a global `display_errors` helper to start refactoring error messages in forms.

## 0.3.1 (September 11, 2012)

### Bug Fix
- Fixed assessment questionaire for Actigraphy.
- Fixed assessment questionaire Chosen use.
- Fixed display of exercise status.
- Fixed SWF file path for pdf/copy/csv functionality on Exercise dashboard for System Admins.
- Fixed Update Result crash - update results functionality should work fully now.

## 0.3.0 (September 7, 2012)

### Enhancements
- Upgraded Rails to 3.2.8
- Added deleted flag functionality.
- Created exercise dashboard that admins can use to track progress for launched exercises.

### Refactoring
- Updated schema to remove redundancies between study, reliability id, and result models.

### Bug Fix
- Fixed missing `delete` image for chosen multi-select fields.
- Fixed assessment type select box in exercise form to show current value.
- Fixed search functionality for Rules and Exercises.
- Fixed  some GUI problems for dates and times.
- Got rid of links and buttons which should not be accessable.

## 0.2.0 (August 15, 2012)

### Enhancements
- Added creator ids to models that had no user assignments.
- Added support for integration testing.
- Set up basic System Admin workflow for launching exercises.
- Set up basic Scorer workflow for adding and editing results.
- Set up basic result assessment functionality.
- Implemented generation of uuids for each user/study/exercise combination.

### Bug Fix
- Fixed project index
- Fixed some link and navigation inconsistencies for scorers and system admins.

## 0.1.1 (July 16, 2012)

### Bug Fix
- Fixed redirect loop caused by root path requiring system admin privelages.
- Fixed many-to-many association definitions.

## 0.1.0 (July 16, 2012)

### Enhancements
- Added email functionality for created users and user status.
- Set up travis ci.
- Disabled email error notifications in production environment.
- Wrote up model objects descriptions and definitions.
- Created basic models, relations, rails scaffolding, and navigation links.
- Converted scaffolding to Contour.
- Ensured all tests were passing.

## 0.0.1 (June 26, 2012)

### Bug Fix
- Fixed user controller and user form to be able to update user status flag and admin flag.
- Ensured all tests were passing

## 0.0.0 (June 19, 2012)

### Enhancements
- Project Skeleton based on remomueller/screen application and remomueller/contour gem
