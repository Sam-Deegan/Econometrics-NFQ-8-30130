# ---------------------------------------------------------------------------
# One-off cleanup: remove the lecture folders left behind by two rounds of
# renaming. Run once from the repo root:
#
#     .\cleanup-stale-folders.ps1
#
# Safe by design. A folder is only removed if it is on the list below AND
# contains nothing but its own placeholder deck. If you have started editing
# something in one of them, or dropped a file in, it is skipped and reported
# rather than deleted.
#
# Delete this script once it has run.
# ---------------------------------------------------------------------------

$stale = @(
    # first scaffold
    '1-1_Variation-and-Where-Data-Comes-From',
    '1-2_Expectation-and-the-Best-Guess-of-y-Given-x',
    '1-3_Why-a-Single-Estimate-Is-the-Wrong-Thing',
    '2-1_Fitting-a-Line-and-Why-This-Line',
    '2-2_How-Much-of-the-Variation-Have-We-Explained',
    '2-3_Is-the-Estimator-Any-Good',
    '2-4_From-an-Estimate-to-a-Claim',
    '3-1_Holding-Other-Things-Fixed',
    '3-2_Making-the-Line-Flexible',
    '3-3_Testing-More-Than-One-Thing-at-a-Time',
    '4-1_Violations-as-Symptoms-Not-as-Tests',
    '4-2_What-OLS-Cannot-License',
    # second scaffold, superseded when the titles were plainer
    '1-2_Expectation-and-the-CEF',
    '1-3_Sampling-and-Inference',
    '2-1_The-Simple-Regression-Model',
    '2-3_The-Properties-of-OLS',
    '2-4_Inference-in-Regression',
    '3-1_Multiple-Regression',
    '4-2_The-Limits-of-OLS'
)

# The thirteen that should survive.
$keep = @(
    '00_Syllabus-and-Introduction',
    '1-1_Data-and-Variation',
    '1-2_Expectation-and-Conditional-Means',
    '1-3_Estimators-and-Sampling-Variation',
    '2-1_Fitting-a-Line',
    '2-2_Goodness-of-Fit',
    '2-3_Bias-and-Precision',
    '2-4_Reporting-an-Estimate',
    '3-1_Adding-Controls',
    '3-2_Functional-Form-and-Dummies',
    '3-3_Joint-Tests-and-Model-Choice',
    '4-1_Diagnosing-Violations',
    '4-2_What-Regression-Cannot-Do'
)

if (-not (Test-Path '_quarto.yml')) {
    Write-Host "Run this from the repo root - _quarto.yml is not here." -ForegroundColor Red
    exit 1
}

$removed = 0
$skipped = 0
$absent  = 0

foreach ($folder in $stale) {
    if (-not (Test-Path -LiteralPath $folder)) { $absent++; continue }

    $files = @(Get-ChildItem -LiteralPath $folder -Recurse -File -Force)
    $unexpected = @($files | Where-Object { $_.Name -notlike 'ECONXXXXX_Lecture_*.qmd' })

    if ($unexpected.Count -gt 0) {
        Write-Host "SKIPPED  $folder" -ForegroundColor Yellow
        foreach ($f in $unexpected) { Write-Host "         holds $($f.Name)" -ForegroundColor Yellow }
        $skipped++
        continue
    }

    Remove-Item -LiteralPath $folder -Recurse -Force
    Write-Host "removed  $folder" -ForegroundColor DarkGray
    $removed++
}

Write-Host ""
Write-Host "$removed removed, $skipped skipped, $absent already gone."

# Report anything unaccounted for, in case a rename was missed.
$present = @(Get-ChildItem -Directory -Name | Where-Object { $_ -match '^\d-\d_|^00_' })
$stray   = @($present | Where-Object { $keep -notcontains $_ })

if ($stray.Count -gt 0) {
    Write-Host ""
    Write-Host "Still present and not on the keep list:" -ForegroundColor Yellow
    $stray | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
} else {
    Write-Host "Thirteen lecture folders remain, as expected." -ForegroundColor Green
}

Write-Host ""
Write-Host "Next:  git add -A" -ForegroundColor Cyan
Write-Host "       git commit -m 'Scaffold Econometrics-I'" -ForegroundColor Cyan
Write-Host "       git push -u origin main" -ForegroundColor Cyan
