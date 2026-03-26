#!/usr/bin/env python3
"""Estimate the average needed on remaining ECON3500 work.

Usage:
    python3 scripts/econ3500_remaining_grade_needed.py 82
    python3 scripts/econ3500_remaining_grade_needed.py 82 --target B
    python3 scripts/econ3500_remaining_grade_needed.py 82 --mode overall

Default behavior assumes the input grade is the student's average on
completed work only. The script then reports the average they would need
across all remaining graded work to finish at each syllabus threshold.

Assumptions baked in from the request:
- stats exam is done
- exam one is done
- idea proposal is done
- problem sets 1, 2, and 3 are done
- labs 1, 2, 3, 4, and 5 are done
- everything else is still open

Notes:
- The syllabus page is internally inconsistent about exam weights. The
  assignment-weight table sums to 100 only if the three exams are worth
  5%, 20%, and 20%. This script uses that 5/20/20 split.
- The research paper overview says the paper is 35% of the final grade
  and splits that 35% internally across its component assignments.
- Assignment quizzes are treated as still open because they were not
  listed as completed in the request.
- RP-01 is treated as the overview page for the paper sequence, not as a
  separate graded item. The early 5% paper component is mapped to the
  idea proposal.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass


@dataclass(frozen=True)
class Assignment:
    name: str
    weight: float
    completed: bool


FINAL_GRADE_THRESHOLDS = [
    ("A/A+", 93.0),
    ("A-", 90.0),
    ("B+", 87.0),
    ("B", 83.0),
    ("B-", 80.0),
    ("C+", 77.0),
    ("C", 73.0),
    ("C-", 70.0),
    ("D+", 67.0),
    ("D", 63.0),
]


RESEARCH_PAPER_WEIGHT = 35.0

# Research paper component shares come from content/assignment/RP-01.md.
ASSIGNMENTS = [
    Assignment("Assignment quizzes", 4.0, False),
    Assignment("Stats exam", 5.0, True),
    Assignment("Exam 1", 20.0, True),
    Assignment("Exam 2", 20.0, False),
    Assignment("PS 1", 8.0 / 5.0, True),
    Assignment("PS 2", 8.0 / 5.0, True),
    Assignment("PS 3", 8.0 / 5.0, True),
    Assignment("PS 4", 8.0 / 5.0, False),
    Assignment("PS 5", 8.0 / 5.0, False),
    Assignment("Lab 1", 8.0 / 8.0, True),
    Assignment("Lab 2", 8.0 / 8.0, True),
    Assignment("Lab 3", 8.0 / 8.0, True),
    Assignment("Lab 4", 8.0 / 8.0, True),
    Assignment("Lab 5", 8.0 / 8.0, True),
    Assignment("Lab 6", 8.0 / 8.0, False),
    Assignment("Lab 7", 8.0 / 8.0, False),
    Assignment("Lab 8", 8.0 / 8.0, False),
    Assignment("RP-02 idea proposal", RESEARCH_PAPER_WEIGHT * 0.05, True),
    Assignment(
        "RP-03 annotated bibliography", RESEARCH_PAPER_WEIGHT * 0.05, False
    ),
    Assignment("RP-04 proposal", RESEARCH_PAPER_WEIGHT * 0.10, False),
    Assignment("RP-05 peer review", RESEARCH_PAPER_WEIGHT * 0.05, False),
    Assignment("RP-06 rough draft (optional)", 0.0, False),
    Assignment("RP-07 presentation", RESEARCH_PAPER_WEIGHT * 0.05, False),
    Assignment("RP-08 final paper", RESEARCH_PAPER_WEIGHT * 0.70, False),
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Compute the average needed on remaining ECON3500 work to hit "
            "a target final grade."
        )
    )
    parser.add_argument(
        "current_grade",
        type=float,
        help=(
            "Current grade as a percentage. By default this should be the "
            "average on completed work only."
        ),
    )
    parser.add_argument(
        "--target",
        help=(
            "Optional target final grade. Accepts a syllabus label such as "
            "'B+' or a numeric percent such as 83."
        ),
    )
    parser.add_argument(
        "--mode",
        choices=("completed", "overall"),
        default="completed",
        help=(
            "'completed' means the input grade is on completed work only. "
            "'overall' means the input is already a weighted overall course "
            "grade with future work effectively counting as zero."
        ),
    )
    return parser.parse_args()


def completed_weight(assignments: list[Assignment]) -> float:
    return sum(item.weight for item in assignments if item.completed)


def remaining_weight(assignments: list[Assignment]) -> float:
    return sum(item.weight for item in assignments if not item.completed)


def current_points_earned(
    current_grade: float,
    mode: str,
    done_weight: float,
) -> float:
    if mode == "completed":
        return current_grade * done_weight / 100.0
    return current_grade


def required_average(
    current_grade: float,
    target_grade: float,
    mode: str,
    done_weight: float,
    open_weight: float,
) -> float:
    earned_so_far = current_points_earned(current_grade, mode, done_weight)
    return 100.0 * (target_grade - earned_so_far) / open_weight


def resolve_target(target: str) -> tuple[str, float]:
    target = target.strip()
    label_to_score = {label.upper(): score for label, score in FINAL_GRADE_THRESHOLDS}

    if target.upper() in label_to_score:
        upper = target.upper()
        return upper, label_to_score[upper]

    try:
        numeric = float(target)
    except ValueError as exc:
        valid_labels = ", ".join(label for label, _ in FINAL_GRADE_THRESHOLDS)
        raise SystemExit(
            f"Could not parse target '{target}'. Use one of: {valid_labels}, or a number."
        ) from exc

    return f"{numeric:.2f}", numeric


def describe_requirement(value: float) -> str:
    if value <= 0:
        return "already secured"
    if value > 100:
        return "impossible (>100%)"
    return f"{value:.2f}%"


def print_assumptions(done_weight: float, open_weight: float) -> None:
    done_items = [item.name for item in ASSIGNMENTS if item.completed and item.weight > 0]
    open_items = [item.name for item in ASSIGNMENTS if not item.completed and item.weight > 0]

    print("Assumptions")
    print(f"- Completed weight: {done_weight:.2f}% of the course grade")
    print(f"- Remaining weight: {open_weight:.2f}% of the course grade")
    print(f"- Completed items: {', '.join(done_items)}")
    print(f"- Remaining items: {', '.join(open_items)}")
    print()


def print_table(current_grade: float, mode: str, done_weight: float, open_weight: float) -> None:
    mode_text = {
        "completed": "completed work only",
        "overall": "overall course grade",
    }[mode]

    print(f"Current grade input: {current_grade:.2f}% ({mode_text})")
    print("Needed average on all remaining graded work")

    for label, threshold in FINAL_GRADE_THRESHOLDS:
        need = required_average(current_grade, threshold, mode, done_weight, open_weight)
        print(f"- {label:>4} ({threshold:>5.2f}%): {describe_requirement(need)}")


def print_single_target(
    current_grade: float,
    target_label: str,
    target_score: float,
    mode: str,
    done_weight: float,
    open_weight: float,
) -> None:
    need = required_average(current_grade, target_score, mode, done_weight, open_weight)
    mode_text = {
        "completed": "completed work only",
        "overall": "overall course grade",
    }[mode]

    print(f"Current grade input: {current_grade:.2f}% ({mode_text})")
    print(
        f"To finish with {target_label}, the student needs "
        f"{describe_requirement(need)} on the remaining graded work."
    )


def main() -> None:
    args = parse_args()

    if not 0 <= args.current_grade <= 100:
        raise SystemExit("Current grade must be between 0 and 100.")

    done_weight = completed_weight(ASSIGNMENTS)
    open_weight = remaining_weight(ASSIGNMENTS)

    if open_weight <= 0:
        raise SystemExit("No remaining graded work is marked as open.")

    print_assumptions(done_weight, open_weight)

    if args.target:
        target_label, target_score = resolve_target(args.target)
        print_single_target(
            current_grade=args.current_grade,
            target_label=target_label,
            target_score=target_score,
            mode=args.mode,
            done_weight=done_weight,
            open_weight=open_weight,
        )
        return

    print_table(
        current_grade=args.current_grade,
        mode=args.mode,
        done_weight=done_weight,
        open_weight=open_weight,
    )


if __name__ == "__main__":
    main()
